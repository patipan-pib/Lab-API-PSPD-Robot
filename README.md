# Robot Framework Tests for Prime API

## Run Locally
```bash
# ติดตั้ง dependencies
pip install -r requirements.txt

# export BASE_URL ให้ Robot รู้ว่าจะยิงไปที่ไหน
export BASE_URL=http://localhost:5000

# รันเทสต์
robot -d reports tests/prime_api.robot
