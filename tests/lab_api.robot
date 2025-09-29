*** Settings ***
Library    RequestsLibrary
Library    Collections

# สร้าง session ครั้งเดียวก่อนรันทดสอบทั้งหมด
Suite Setup    Create Session    prime    ${BASE_URL}

*** Variables ***
# แก้ค่าเป็นปลายทางจริงได้ เช่น http://<ip-vm3>:5000
${BASE_URL}    http://localhost:5000

*** Test Cases ***

# ---------- / (welcome) ----------
Test Welcome Endpoint
    # เรียก GET ผ่าน session "prime" ที่ผูกกับ BASE_URL แล้ว
    ${resp}=    Get On Session    prime    /
    Should Be Equal As Integers    ${resp.status_code}    200

    # ใช้ resp.json() (แทน To Json)
    ${data}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${data}    message

# ---------- /is_prime/<n> ----------
Test Prime Number Endpoint
    ${resp}=    Get On Session    prime    /is_prime/17
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Set Variable    ${resp.json()}
    Should Be True    ${data['is_prime']}

# # ---------- /primes?start=10&end=20 ----------
# Test Prime Range Endpoint
#     ${resp}=    Get On Session    prime    /primes    params={"start":10,"end":12}
#     Should Be Equal As Integers    ${resp.status_code}    200

#     ${data}=      Set Variable    ${resp.json()}
#     ${primes}=    Get From Dictionary    ${data}    primes

#     # แปลง expected เป็น int ก่อนเปรียบเทียบ
#     ${e11}=    Convert To Integer    11
#     ${e13}=    Convert To Integer    13
#     ${e17}=    Convert To Integer    17
#     ${e19}=    Convert To Integer    19

#     List Should Contain Value    ${primes}    ${e11}
#     List Should Contain Value    ${primes}    ${e13}
#     List Should Contain Value    ${primes}    ${e17}
#     List Should Contain Value    ${primes}    ${e19}
#     Should Be Equal As Integers  ${data['count']}    4