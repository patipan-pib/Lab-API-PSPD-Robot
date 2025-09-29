*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem

# ใช้คีย์เวิร์ด Init Session แทน เพื่อเลือก BASE_URL จาก ENV ถ้ามี
Suite Setup    Init Session

*** Variables ***
${DEFAULT_BASE_URL}    http://localhost:5000


*** Keywords ***
Init Session
    ${base}=    Get Environment Variable    BASE_URL    ${DEFAULT_BASE_URL}
    Log    Using BASE_URL: ${base}
    Create Session    prime    ${base}

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
Test Prime Number Endpoint 17
    ${resp}=    Get On Session    prime    /is_prime/17
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Set Variable    ${resp.json()}
    Should Be True    ${data['is_prime']}

Test Prime Number Endpoint 19
    ${resp}=    Get On Session    prime    /is_prime/19
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Set Variable    ${resp.json()}
    Should Be True    ${data['is_prime']}

Test Prime Number Endpoint 23
    ${resp}=    Get On Session    prime    /is_prime/23
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Set Variable    ${resp.json()}
    Should Be True    ${data['is_prime']}

Test Prime Number Endpoint 20
    ${resp}=    Get On Session    prime    /is_prime/20
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Set Variable    ${resp.json()}
    Should Be Equal    ${data['is_prime']}    ${False}

Test Prime Number Endpoint 25
    ${resp}=    Get On Session    prime    /is_prime/25
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Set Variable    ${resp.json()}
    Should Be Equal    ${data['is_prime']}    ${False}

# ---------- /is_prime/<n> ----------
# Test Prime Number Endpoint 2 
#     ${resp}=    Get On Session    prime    /is_prime/15
#     Should Be Equal As Integers    ${resp.status_code}    200
#     ${data}=    Set Variable    ${resp.json()}
#     Should Be True    ${data['is_prime']}

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