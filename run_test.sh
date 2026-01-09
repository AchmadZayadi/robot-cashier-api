#!/bin/bash


mkdir -p results

robot --outputdir results \
  test/login.robot \
  test/product.robot \
  test/inquiry.robot \
  test/payment.robot \
  test/payment.robot \
  test/receipt.robot
  python3 library/notif_google_space.py
  python3 library/generate_pdf_report.py