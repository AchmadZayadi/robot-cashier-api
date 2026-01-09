import xml.etree.ElementTree as ET
from fpdf import FPDF
import matplotlib.pyplot as plt
import os
import json
import re
from datetime import datetime

def parse_robot_results(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    test_results = []
    passed_count, failed_count = 0, 0

    for test in root.iter('test'):
        name = test.get('name')
        status_final = test.find('status').get('status')
        method, res_code, res_status = "-", "-", "-"
        req_body, res_body = "No Request Body Found", "No Response Body Found"
        
        for msg in test.iter('msg'):
            text = msg.text if msg.text else ""
            if any(x in text for x in ["Request :", "method="]):
                m = re.search(r'(POST|GET|PUT|DELETE|PATCH)', text)
                if m: method = m.group(1)
                req_match = re.search(r'(?:Request Body:|body=)\s*(.*)', text, re.DOTALL)
                if req_match: req_body = req_match.group(1).strip()
            
            code_match = re.search(r"['\"]responseCode['\"]:\s*(\d+)", text)
            if code_match: res_code = code_match.group(1)
            status_match = re.search(r"['\"]status['\"]:\s*['\"](\w+)['\"]", text)
            if status_match: res_status = status_match.group(1)
            if '"responseCode"' in text and '"status"' in text: res_body = text

        test_results.append({"name": name, "method": method, "code": res_code, "status": res_status, "result": status_final, "req": req_body, "res": res_body})
        if status_final == 'PASS': passed_count += 1
        else: failed_count += 1
            
    return test_results, passed_count, failed_count

def create_pie_chart(passed, failed):
    labels = [f'Passed ({passed})', f'Failed ({failed})']
    colors = ['#2ecc71', '#e74c3c']
    plt.figure(figsize=(6, 4))
    plt.pie([passed, failed], labels=labels, colors=colors, autopct='%1.1f%%', startangle=90)
    plt.axis('equal')
    plt.tight_layout()
    plt.savefig('pie_chart.png', transparent=True)
    plt.close()

def generate_pdf(test_results, passed, failed):
    # Lebar total tabel (10 + 115 + 20 + 30 + 30 + 30 = 235mm)
    total_width = 235
    pdf = FPDF(orientation='L', unit='mm', format='A4')
    pdf.set_auto_page_break(auto=True, margin=15)
    pdf.add_page()
    
    # --- HEADER ---
    pdf.set_font("Arial", 'B', 20)
    pdf.set_text_color(44, 62, 80)
    pdf.cell(0, 15, "API AUTOMATION EXECUTIVE REPORT", ln=True, align='C')
    pdf.ln(5)

    # --- 1. PROJECT INFO (Full Width) ---
    pdf.set_font("Arial", 'B', 10)
    pdf.set_fill_color(240, 240, 240)
    summary = [
        ["Project Name", "POS System API Delivery"],
        ["QA Engineer", "Your Professional Name"],
        ["Date Execution", datetime.now().strftime("%d %B %Y")]
    ]
    
    # Set margin agar center (A4 L = 297mm, Tabel = 235mm, Sisa = 62mm / 2 = 31mm)
    margin_left = 31
    for row in summary:
        pdf.set_x(margin_left)
        pdf.set_font("Arial", 'B', 10)
        pdf.cell(50, 8, row[0], 1, 0, 'L', True)
        pdf.set_font("Arial", '', 10)
        pdf.cell(total_width - 50, 8, row[1], 1, 1, 'L')

    # --- 2. PIE CHART (Diletakkan di Tengah) ---
    create_pie_chart(passed, failed)
    # Menaruh diagram tepat di bawah project info
    chart_y = pdf.get_y() + 5
    pdf.image('pie_chart.png', x=110, y=chart_y, w=75)
    
    # --- 3. EXECUTION SUMMARY LOG (Di bawah diagram) ---
    pdf.set_y(chart_y + 55) # Memberi jarak setelah diagram
    pdf.set_x(margin_left)
    pdf.set_font("Arial", 'B', 12)
    pdf.set_text_color(44, 62, 80)
    pdf.cell(0, 10, "1. Execution Summary Log", ln=True)
    
    pdf.set_x(margin_left)
    pdf.set_font("Arial", 'B', 9); pdf.set_fill_color(52, 152, 219); pdf.set_text_color(255)
    headers = ["No", "Scenario Name", "Method", "Resp Code", "Resp Status", "Result"]
    widths = [10, 115, 20, 30, 30, 30]
    for i, h in enumerate(headers): pdf.cell(widths[i], 10, h, 1, 0, 'C', True)
    pdf.ln()

    pdf.set_font("Arial", '', 9); pdf.set_text_color(0)
    for i, row in enumerate(test_results, 1):
        pdf.set_x(margin_left)
        pdf.cell(10, 8, str(i), 1, 0, 'C')
        pdf.cell(115, 8, row['name'][:80], 1)
        pdf.cell(20, 8, row['method'], 1, 0, 'C')
        pdf.cell(30, 8, row['code'], 1, 0, 'C')
        pdf.cell(30, 8, row['status'], 1, 0, 'C')
        pdf.set_text_color(46, 204, 113) if row['result'] == 'PASS' else pdf.set_text_color(231, 76, 60)
        pdf.cell(30, 8, row['result'], 1, 1, 'C')
        pdf.set_text_color(0)

    # --- 4. DETAIL VERTICAL (Halaman Berikutnya) ---
    pdf.add_page()
    pdf.set_font("Arial", 'B', 14)
    pdf.cell(0, 10, "2. Full Payload Analysis (Vertical View)", ln=True)
    pdf.ln(5)
    
    for i, row in enumerate(test_results, 1):
        pdf.set_font("Arial", 'B', 10); pdf.set_fill_color(44, 62, 80); pdf.set_text_color(255)
        pdf.cell(0, 8, f"Scenario {i}: {row['name']}", 1, 1, 'L', True)
        pdf.set_font("Arial", 'B', 9); pdf.set_fill_color(240); pdf.set_text_color(0)
        pdf.cell(0, 7, "Request Body:", 1, 1, 'L', True)
        pdf.set_font("Courier", '', 8)
        pdf.multi_cell(0, 5, row['req'], 1, 'L')
        pdf.set_font("Arial", 'B', 9); pdf.set_fill_color(240)
        pdf.cell(0, 7, "Response Body:", 1, 1, 'L', True)
        pdf.set_font("Courier", '', 8)
        pdf.multi_cell(0, 5, row['res'], 1, 'L')
        pdf.ln(8)
        if pdf.get_y() > 180: pdf.add_page()

    pdf.output("Automation_Final_Report.pdf")

if __name__ == "__main__":
    output_xml = "results/output.xml"
    if os.path.exists(output_xml):
        data, p, f = parse_robot_results(output_xml)
        generate_pdf(data, p, f)
        print("Success: Updated Professional Report Generated.")