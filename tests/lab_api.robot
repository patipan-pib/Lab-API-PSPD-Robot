*** Settings ***
# ใช้ RequestsLibrary เพื่อยิง API
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

# กำหนด URL หลัก ของ API (แก้ BASE_URL เป็นของจริงเช่น localhost:5000 หรือ VM3 IP)
Suite Setup    Create Session    prime    ${BASE_URL}

*** Variables ***
${BASE_URL}    http://localhost:5000

*** Test Cases ***

# =============================
# ทดสอบ API /welcome
# =============================
Test Welcome Endpoint
    [Documentation]    ตรวจสอบว่า endpoint /welcome ส่งข้อความ Welcome
    ${resp}=    GET    prime    /
    Should Be Equal As Strings    ${resp.status_code}    200
    ${body}=    To JSON    ${resp.content}
    Should Contain    ${body['message']}    Welcome

# =============================
# ทดสอบ API /is_prime/<n>
# =============================
Test Prime Number Endpoint
    [Documentation]    ตรวจสอบว่า /is_prime/17 คืนค่า true
    ${resp}=    GET    prime    /is_prime/17
    Should Be Equal As Strings    ${resp.status_code}    200
    ${body}=    To JSON    ${resp.content}
    Should Be Equal    ${body['is_prime']}    ${True}

# =============================
# ทดสอบ API /primes?start=10&end=20
# =============================
Test Prime Range Endpoint
    [Documentation]    ตรวจสอบว่า /primes?start=10&end=20 มีจำนวนเฉพาะในช่วง
    ${resp}=    GET    prime    /primes?start=10&end=20
    Should Be Equal As Strings    ${resp.status_code}    200
    ${body}=    To JSON    ${resp.content}
    List Should Contain Value    ${body['primes']}    11
    List Should Contain Value    ${body['primes']}    13
    List Should Contain Value    ${body['primes']}    17
    List Should Contain Value    ${body['primes']}    19
    Should Be Equal As Numbers    ${body['count']}    4
