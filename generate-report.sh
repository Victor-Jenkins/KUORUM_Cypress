#!/bin/bash

# Ejecutar pruebas de Cypress y guardar logs
npx cypress run 2>&1 | tee cypress-logs.txt || true

# Contar resultados de las pruebas
passed=$(grep -oP '✔.*\d+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+' cypress-logs.txt | awk '{ sum += $4 } END { print sum }')
failed=$(grep -oP '✔.*\d+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+' cypress-logs.txt | awk '{ sum += $5 } END { print sum }')
skipped=$(grep -oP '✔.*\d+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+' cypress-logs.txt | awk '{ sum += $6 } END { print sum }')
total=$((passed + failed + skipped))
passed_percent=$((total > 0 ? passed * 100 / total : 0))
failed_percent=$((total > 0 ? failed * 100 / total : 0))
skipped_percent=$((total > 0 ? skipped * 100 / total : 0))

# Generar informe HTML con los resultados
cat <<EOF > cypress-report.html
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #2a2a2a;
      color: white;
    }
    .header {
      padding: 20px;
      background-color: #1a1a1a;
      text-align: center;
    }
    .report-title {
      font-size: 24px;
      margin-bottom: 10px;
    }
    .log-container {
      background-color: #1a1a1a;
      padding: 20px;
    }
    pre {
      background-color: #1a1a1a;
      border: none;
      color: white;
    }
  </style>
</head>
<body>
<div class='header'>
  <h1 class='report-title'>Cypress Test Report</h1>
</div>
<div class='log-container'>
  <p>Pass: $passed ($passed_percent%)</p>
  <p>Fail: $failed ($failed_percent%)</p>
  <p>Skip: $skipped ($skipped_percent%)</p>
</div>
</body>
</html>
EOF

echo "Informe HTML generado: cypress-report.html"
