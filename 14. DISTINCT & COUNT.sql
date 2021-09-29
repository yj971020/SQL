
--------------
DISTINCT(중복값 제거)
COUNT
_____________________


> 아이돌 멤버테이블에서 아이돌 그룹 이름을 출력하시오
  단, 중복제거
  ----------------------------------------------
    SELECT `GROUP_NAME`
    FROM lecture.idol_member;

    SELECT DISTINCT `GROUP_NAME`
    FROM lecture.idol_member;
  ----------------------------------------------


> 아이돌 멤버테이블에 있는 모든 멤버의 총 인원 수 출력
  ------------------------------------------------
    SELECT COUNT(*)
    FROM lecture.idol_member;
  ------------------------------------------------


> 아이돌 멤버테이블에 있는 그룹의 총 개수를 출력
  ------------------------------------------------
    SELECT 
        COUNT(DISTINCT GROUP_NAME)
        AS `GROUP_COUNT`
    FROM lecture.idol_member;
  ------------------------------------------------


> 트와이스 그룹의 총 멤버 수를 출력하시오
  ------------------------------------------------
    SELECT 
        GROUP_NAME, 
        COUNT(GROUP_NAME)
    FROM lecture.idol_member
    WHERE GROUP_NAME = '트와이스';
  ------------------------------------------------ 


> 각 그룹별 총 멤버 수를 출력하시오
  ------------------------------------------------
    SELECT 
        GROUP_NAME, 
        COUNT(GROUP_NAME)
    FROM lecture.idol_member
    GROUP BY `GROUP_NAME`;
  ------------------------------------------------ 