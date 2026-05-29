#!/bin/bash
BASE="http://localhost:3000"

echo "=== 1: Equipment with bad category_id ==="
curl -s -w " [HTTP %{http_code}]\n" -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Orphan","serial_number":"XXX-000","status":"available","category_id":999}}'

echo "=== 2: Duplicate serial ==="
curl -s -w " [HTTP %{http_code}]\n" -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Dup","serial_number":"UNQ-999","status":"available","category_id":1}}'
curl -s -w " [HTTP %{http_code}]\n" -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Dup2","serial_number":"UNQ-999","status":"available","category_id":1}}'

echo "=== 3: Invalid status ==="
curl -s -w " [HTTP %{http_code}]\n" -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Bad","serial_number":"ZZZ-999","status":"broken","category_id":1}}'

echo "=== 4: Duplicate category name ==="
curl -s -w " [HTTP %{http_code}]\n" -X POST "$BASE/categories" -H "Content-Type: application/json" -d '{"category":{"name":"Computing"}}'

echo "=== 5: Maintenance record with bad equipment_id ==="
curl -s -w " [HTTP %{http_code}]\n" -X POST "$BASE/maintenance_records" -H "Content-Type: application/json" -d '{"maintenance_record":{"description":"Fix","performed_at":"2024-01-01T00:00:00","equipment_id":999}}'

echo "=== 6: Delete category with equipment ==="
curl -s -w " [HTTP %{http_code}]\n" -X DELETE "$BASE/categories/1"

echo "=== 7: Category not found ==="
curl -s -w " [HTTP %{http_code}]\n" -X GET "$BASE/categories/999"

echo "=== 8: Equipment not found ==="
curl -s -w " [HTTP %{http_code}]\n" -X GET "$BASE/equipment/999"

echo "=== 9: PATCH category not found ==="
curl -s -w " [HTTP %{http_code}]\n" -X PATCH "$BASE/categories/999" -H "Content-Type: application/json" -d '{"category":{"name":"New"}}'

echo "=== 10: Future maintenance date ==="
curl -s -w " [HTTP %{http_code}]\n" -X POST "$BASE/maintenance_records" -H "Content-Type: application/json" -d '{"maintenance_record":{"description":"Future","performed_at":"2099-01-01T00:00:00","equipment_id":1}}'
