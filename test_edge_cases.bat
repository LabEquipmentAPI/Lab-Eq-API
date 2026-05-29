@echo off
set BASE=http://localhost:3000

echo === Edge Case 1: Category name too short ===
curl -s -X POST "%BASE%/categories" -H "Content-Type: application/json" -d "{\"category\":{\"name\":\"AB\"}}"
echo.

echo.
echo === Edge Case 2: Invalid serial number ===
curl -s -X POST "%BASE%/equipment" -H "Content-Type: application/json" -d "{\"equipment\":{\"name\":\"Bad\",\"serial_number\":\"lap-001\",\"status\":\"available\",\"category_id\":1}}"
echo.

echo.
echo === Edge Case 3: Duplicate serial number ===
curl -s -X POST "%BASE%/equipment" -H "Content-Type: application/json" -d "{\"equipment\":{\"name\":\"Dup\",\"serial_number\":\"UNQ-999\",\"status\":\"available\",\"category_id\":1}}"
echo.
curl -s -X POST "%BASE%/equipment" -H "Content-Type: application/json" -d "{\"equipment\":{\"name\":\"Dup2\",\"serial_number\":\"UNQ-999\",\"status\":\"available\",\"category_id\":1}}"
echo.

echo.
echo === Edge Case 4: Future maintenance date ===
curl -s -X POST "%BASE%/maintenance_records" -H "Content-Type: application/json" -d "{\"maintenance_record\":{\"description\":\"Future\",\"performed_at\":\"2099-01-01T00:00:00\",\"equipment_id\":1}}"
echo.

echo.
echo === Edge Case 5: Invalid status ===
curl -s -X POST "%BASE%/equipment" -H "Content-Type: application/json" -d "{\"equipment\":{\"name\":\"Bad Status\",\"serial_number\":\"ZZZ-999\",\"status\":\"broken\",\"category_id\":1}}"
echo.

echo.
echo === Edge Case 6: Delete category with equipment ===
curl -s -X DELETE "%BASE%/categories/1"
echo.

echo.
echo === Edge Case 7: Category not found ===
curl -s -X GET "%BASE%/categories/99999"
echo.

echo.
echo === Edge Case 8: Equipment not found ===
curl -s -X GET "%BASE%/equipment/99999"
echo.

echo.
echo === Edge Case 9: Maintenance record not found ===
curl -s -X GET "%BASE%/maintenance_records/99999"
echo.

echo.
echo === Edge Case 10: Equipment with non-existent category ===
curl -s -X POST "%BASE%/equipment" -H "Content-Type: application/json" -d "{\"equipment\":{\"name\":\"Orphan\",\"serial_number\":\"XXX-000\",\"status\":\"available\",\"category_id\":99999}}"
echo.
