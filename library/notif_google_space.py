import      os
import      xml.etree.ElementTree as ET
import      requests

WEBHOOK_URL = 'https://chat.googleapis.com/v1/spaces/AAQAvmtBx_U/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=55AckF1qHnLYiknLj_jMbua9wMi9wmS4_4h1kGK33nI'
TEAM_NAME = "Gledeg Gatotkaca"
PROJECT_NAME = "Cashier"
EXECUTED_BY = "Zays Keren"

def parse_robot_results(file_path):
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    tree = ET.parse(file_path)
    root = tree.getroot()

    start_time = root.attrib.get('generated', 'N/A')

    # Ambil suite paling luar (top-level suite) dan ambil durasi dari elemen <status>
    top_suite = root.find('suite')
    duration_elem = top_suite.find('status') if top_suite is not None else None
    duration = duration_elem.attrib.get('elapsed', '0') if duration_elem is not None else '0'

    total_pass = 0
    total_fail = 0
    suite_results = []

    suites = root.findall('.//suite')

    for suite in suites:
        name = suite.attrib.get('name', None)
        if not name:
            continue  # skip if no name

        passed = 0
        failed = 0
        testcase_list = []

        for test in suite.findall('test'):
            test_name = test.attrib.get('name', 'Unnamed Test')
            status_elem = test.find('status')
            status = status_elem.attrib.get('status') if status_elem is not None else "UNKNOWN"
            testcase_list.append((test_name, status))

            if status == 'PASS':
                passed += 1
            elif status == 'FAIL':
                failed += 1

        if passed == 0 and failed == 0:
            continue  # skip suites without any executed test

        suite_results.append({
            'name': name,
            'passed': passed,
            'failed': failed,
            'testcases': testcase_list
        })

        total_pass += passed
        total_fail += failed

    return {
        'start_time': start_time,
        'duration': duration,
        'suites': suite_results,
        'total_passed': total_pass,
        'total_failed': total_fail
    }

def send_to_gspace(data):
    try:
        duration_seconds = float(data['duration'])
    except (ValueError, TypeError):
        duration_seconds = 0.0

    hours = int(duration_seconds // 3600)
    minutes = int((duration_seconds % 3600) // 60)
    seconds = duration_seconds % 60  # Sisanya adalah detik desimal

    duration_formatted = f"{hours:02}:{minutes:02}:{seconds:06.3f}"

    widgets = [
        {
            "keyValue": {
                "topLabel": "TEAM",
                "content": TEAM_NAME
            }
        },
        {
            "keyValue": {
                "topLabel": "PROJECT",
                "content": PROJECT_NAME
            }
        },
        {
            "keyValue": {
                "topLabel": "EXECUTED BY",
                "content": EXECUTED_BY
            }
        },
        {
            "keyValue": {
                "topLabel": "START TIME",
                "content": data['start_time']
            }
        },
        {
            "keyValue": {
                "topLabel": "DURATION",
                "content": duration_formatted
            }
        },
        {
            "keyValue": {
                "topLabel": "SUMMARY TESTING",
                "content": f"✅ PASSED: {data['total_passed']} | ❌ FAILED: {data['total_failed']}"
            }
        }
    ]

    # Hanya tampilkan suite yang memiliki test case
    for suite in data['suites']:
        widgets.append({
            "textParagraph": {
                "text": f"<br><b>📁 TEST SUITES: </b> {suite['name']} ==> ✅ Passed: {suite['passed']} | ❌ Failed: {suite['failed']}<br><br>"
            }
        })

        for test_name, status in suite['testcases']:
            status_icon = "✅" if status == "PASS" else "❌"
            widgets.append({
                "textParagraph": {
                    "text": f"{status_icon} {test_name}"
                }
            })

    payload = {
        "cards": [
            {
                "header": {
                    "title": "🤖 Robot Framework Test Report",
                    "subtitle": f"{PROJECT_NAME} - Executed by {EXECUTED_BY}"
                },
                "sections": [
                    {
                        "widgets": widgets
                    }
                ]
            }
        ]
    }

    headers = {'Content-Type': 'application/json; charset=UTF-8'}
    response = requests.post(WEBHOOK_URL, headers=headers, json=payload)
    if response.status_code == 200:
        print("✅ Notification sent to GSpace!")
    else:
        print("❌ Failed to send notification:", response.text)

if __name__ == "__main__":
    base_dir = os.path.dirname(os.path.abspath(__file__))
    result_path = os.path.join(base_dir, "../results/output.xml")

    try:
        result_data = parse_robot_results(result_path)
        send_to_gspace(result_data)
    except Exception as e:
        print("❌ Error:", str(e))
