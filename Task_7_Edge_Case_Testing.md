# Task 7: Edge Case Testing & curl Documentation

## Prerequisites
Make sure your server is running and seeded:
```bash
bin/rails db:seed
bin/rails server
```

---

## Edge Case 1: Create Category with Name Too Short (< 3 characters)
**Rule:** Category name must be at least 3 characters.

```bash
curl -X POST http://localhost:3000/categories -H "Content-Type: application/json" -d '{"category": {"name": "AB"}}'
```

**Expected Response (422 Unprocessable Entity):**
```json
{"errors":["Name is too short (minimum is 3 characters)"]}
```

---

## Edge Case 2: Create Equipment with Invalid Serial Number Format
**Rule:** Serial number must match XXX-NNN (three uppercase letters, dash, three digits).

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Bad Serial", "serial_number": "lap-001", "status": "available", "category_id": 1}}'
```

**Expected Response (422 Unprocessable Entity):**
```json
{"errors":["Serial number is invalid"]}
```

---

## Edge Case 3: Create Equipment with Duplicate Serial Number
**Rule:** Serial number must be unique.

```bash
# First, create an equipment with a serial number
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "First Laptop", "serial_number": "UNQ-999", "status": "available", "category_id": 1}}'

# Then try to create another with the same serial number
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Second Laptop", "serial_number": "UNQ-999", "status": "available", "category_id": 1}}'
```

**Expected Response (422 Unprocessable Entity):**
```json
{"errors":["Serial number has already been taken"]}
```

---

## Edge Case 4: Create Maintenance Record with Future Date
**Rule:** Maintenance date cannot be in the future.

```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record": {"description": "Future fix", "performed_at": "2099-01-01T00:00:00", "equipment_id": 1}}'
```

**Expected Response (422 Unprocessable Entity):**
```json
{"errors":["Performed at cannot be in the future"]}
```

---

## Edge Case 5: Create Equipment with Invalid Status
**Rule:** Status must be one of: available, in_use, maintenance.

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Broken Thing", "serial_number": "ZZZ-999", "status": "broken", "category_id": 1}}'
```

**Expected Response (422 Unprocessable Entity):**
```json
{"errors":["Status is not included in the list"]}
```

---

## Edge Case 6: Delete Category That Has Equipment
**Rule:** Cannot delete a category that still has equipment items.

```bash
# Try to delete a category that has equipment (e.g., category_id: 1)
curl -X DELETE http://localhost:3000/categories/1
```

**Expected Response (409 Conflict):**
```json
{"error":"Cannot delete category. 2 equipment items still belong to it."}
```
*(Note: The count will match however many equipment items belong to that category.)*

---

## Edge Case 7: Get Non-Existent Category

```bash
curl -X GET http://localhost:3000/categories/99999
```

**Expected Response (404 Not Found):**
```json
{"error":"Category not found"}
```

---

## Edge Case 8: Get Non-Existent Equipment

```bash
curl -X GET http://localhost:3000/equipment/99999
```

**Expected Response (404 Not Found):**
```json
{"error":"Equipment not found"}
```

---

## Edge Case 9: Get Non-Existent Maintenance Record

```bash
curl -X GET http://localhost:3000/maintenance_records/99999
```

**Expected Response (404 Not Found):**
```json
{"error":"Maintenance record not found"}
```

---

## Edge Case 10: Create Equipment with Non-Existent Category ID

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Orphan Equipment", "serial_number": "XXX-000", "status": "available", "category_id": 99999}}'
```

**Expected Response (422 Unprocessable Entity):**
```json
{"errors":["Category must exist"]}
```

---

## Quick Test Script (Run All at Once)

Save this as `test_edge_cases.sh` and run `bash test_edge_cases.sh`:

```bash
#!/bin/bash
BASE="http://localhost:3000"

echo "=== Edge Case 1: Category name too short ==="
curl -s -X POST "$BASE/categories" -H "Content-Type: application/json" -d '{"category":{"name":"AB"}}' | jq .

echo -e "
=== Edge Case 2: Invalid serial number ==="
curl -s -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Bad","serial_number":"lap-001","status":"available","category_id":1}}' | jq .

echo -e "
=== Edge Case 3: Duplicate serial number ==="
curl -s -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Dup","serial_number":"UNQ-999","status":"available","category_id":1}}' | jq .
curl -s -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Dup2","serial_number":"UNQ-999","status":"available","category_id":1}}' | jq .

echo -e "
=== Edge Case 4: Future maintenance date ==="
curl -s -X POST "$BASE/maintenance_records" -H "Content-Type: application/json" -d '{"maintenance_record":{"description":"Future","performed_at":"2099-01-01T00:00:00","equipment_id":1}}' | jq .

echo -e "
=== Edge Case 5: Invalid status ==="
curl -s -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Bad Status","serial_number":"ZZZ-999","status":"broken","category_id":1}}' | jq .

echo -e "
=== Edge Case 6: Delete category with equipment ==="
curl -s -X DELETE "$BASE/categories/1" | jq .

echo -e "
=== Edge Case 7: Category not found ==="
curl -s -X GET "$BASE/categories/99999" | jq .

echo -e "
=== Edge Case 8: Equipment not found ==="
curl -s -X GET "$BASE/equipment/99999" | jq .

echo -e "
=== Edge Case 9: Maintenance record not found ==="
curl -s -X GET "$BASE/maintenance_records/99999" | jq .

echo -e "
=== Edge Case 10: Equipment with non-existent category ==="
curl -s -X POST "$BASE/equipment" -H "Content-Type: application/json" -d '{"equipment":{"name":"Orphan","serial_number":"XXX-000","status":"available","category_id":99999}}' | jq .
```

---

## Model Validations Checklist (Task 6)

Verify these in `rails console`:

```ruby
# Rule 1: Serial number format
Equipment.new(name: "Test", serial_number: "LAP-001", status: "available", category_id: 1).valid?  # true
Equipment.new(name: "Test", serial_number: "lap-001", status: "available", category_id: 1).valid?  # false

# Rule 2: Maintenance date not in future
MaintenanceRecord.new(description: "Fix", performed_at: 1.week.from_now, equipment_id: 1).valid?  # false
MaintenanceRecord.new(description: "Fix", performed_at: 1.week.ago, equipment_id: 1).valid?     # true

# Rule 3: Category name minimum length
Category.new(name: "AB").valid?      # false
Category.new(name: "ABC").valid?     # true

# Rule 4: Equipment status inclusion
Equipment.new(name: "Test", serial_number: "LAP-002", status: "broken", category_id: 1).valid?  # false
Equipment.new(name: "Test", serial_number: "LAP-002", status: "available", category_id: 1).valid?  # true
```
