
-----------
부조회(서브쿼리, INNER QUERY)
: 쿼리 안에 있는 또 다른 쿼리
________________________
서브쿼리를 사용하는 경우
:구절의 순서를 바꿔야 하는 경우
 먼저 수행해서 결과를 남겨야 하는 경우

SELECT 
FROM 
WHERE 
GROUP BY 
HAVING 
ORDER BY 
_______________




        NOTICE 테이블에서 최신 등록순으로 정렬한 결과에서 
        상위 10개의 게시글을 원하는 경우라면?

        
        SELECT WRITER_ID, TITLE, REGDATE,
            DENSE_RANK() OVER(ORDER BY REGDATE DESC) `NO`
        FROM NOTICE
        WHERE `NO` BETWEEN 1 AND 10;
        -- 오류발생! ( 실행순서는 from-> where -> select 이기 때문에 no 를 where 절에서 먼저 찾지 못함)


        SELECT A.WRITER_ID, A.TITLE, A.REGDATE, A.`NO`
        FROM   A
        WHERE  A.`NO` BETWEEN 1 AND 10;


        SELECT WRITER_ID, TITLE, REGDATE, 
            DENSE_RANK() OVER(ORDER BY REGDATE DESC) `NO`
        FROM NOTICE;


        SELECT A.WRITER_ID, A.TITLE, A.REGDATE, A.`NO`
        FROM   
            (
                SELECT WRITER_ID, TITLE, REGDATE, 
                    DENSE_RANK() OVER(ORDER BY REGDATE DESC) `NO`
                FROM NOTICE
            ) A
        WHERE  A.`NO` BETWEEN 1 AND 10;



    > IDOL_MEMBER 테이블에서 나이가 27세 이상인 멤버를 조회하시오
        ----------------------------------------------------
         SELECT GROUP_NAME, MEMBER_NAME, YEAR(NOW())-YEAR(BIRTHDAY)+1 AGE
         FROM IDOL_MEMBER
         WHERE AGE >= 27;
         -- ERROR 1054 (42S22): Unknown column 'AGE' in 'where clause'   


        SELECT A.GROUP_NAME, A.MEMBER_NAME, A.AGE
         FROM (SELECT GROUP_NAME, MEMBER_NAME, YEAR(NOW())-YEAR(BIRTHDAY)+1 AGE 
              FROM IDOL_MEMBER) A
         WHERE A.AGE >= 27;
         
        --서브쿼리를 사용하진 않았지만 간단한 방법
        SELECT GROUP_NAME, MEMBER_NAME, YEAR(NOW())-YEAR(BIRTHDAY)+1 AGE
         FROM IDOL_MEMBER
         HAVING AGE >= 27;

        ----------------------------------------------------


    > IDOL_MEMBER 테이블에서 평균 나이 이상인 멤버를 조회하시오
        ----------------------------------------------------
        SELECT ROUND(AVG(YEAR(NOW())-YEAR(BIRTHDAY)+1))
        FROM IDOL_MEMBER;


      SELECT GROUP_NAME, MEMBER_NAME, YEAR(NOW())-YEAR(BIRTHDAY)+1 AGE
         FROM IDOL_MEMBER
         HAVING AGE >= (  SELECT ROUND(AVG(YEAR(NOW())-YEAR(BIRTHDAY)+1))
        FROM IDOL_MEMBER);

    SELECT A.GROUP_NAME, A.MEMBER_NAME, A.AGE
    FROM (SELECT GROUP_NAME, MEMBER_NAME, YEAR(NOW())-YEAR(BIRTHDAY)+1 AGE FROM IDOL_MEMBER
    ) A
    where A.AGE >= (
    SELECT ROUND(AVG(YEAR(NOW())-YEAR(BIRTHDAY)+1)) FROM IDOL_MEMBER
    ) order by A.AGE DESC;



  -- WITH 절 이용하여 가상테이블 생성
  WITH TBL AS
  (
    SELECT GROUP_NAME,MEMBER_NAME,
     YEAR(NOW())-YEAR(BIRTHDAY)+1 AGE 
     FROM IDOL_MEMBER
  )

  SELECT GROUP_NAME, MEMBER_NAME, AGE
  FROM TBL
  WHERE AGE >= (SELECT AVG(TBL.AGE) FROM TBL);


        ----------------------------------------------------





-- 위치에 따라 사용되는 서브쿼리

1. SELECT 절에서 사용되는 서브쿼리(Scalar Subquery)
  : 하나의 레코드에 하나의 값을 리턴하는 서브쿼리
    컬럼값이 오는 모든 자리에 사용

    > NOTICE TABLE로부터 작성자(sjpark)의 게시글 HIT 평균값
      과 HIT 수를 출력하시오 
        ----------------------------------------------------
     
     SELECT TITLE , WRITER_ID, HIT,
      (
        SELECT AVG(HIT) 
        FROM notice 
        WHERE WRITER_ID="sjpark"
        ) as AVG_HIT
     FROM NOTICE WHERE WRITER_ID="sjpark";







        ----------------------------------------------------

    > CITY 정보를 조회(단, 해당 도시의 나라이름 포함)하시오
        ----------------------------------------------------
      SELECT A.NAME, A.COUNTRYCODE,
         (

         SELECT B.NAME 
         FROM COUNTRY B 
         WHERE A.COUNTRYCODE = B.CODE 
      
         ) AS COUNTRYNAME, POPULATION
      FROM CITY A;




        ----------------------------------------------------



        
2. FROM 절에서 사용되는 서브쿼리(Inline View)

     > NOTICE TALBE로부터 작성자(sjpark)의 게시글 HIT수가 15 이상인
       게시글들을 출력하시오 
        ----------------------------------------------------

    --서브쿼리 안쓸경우
     SELECT TITLE, WRITER_ID, hit 
     FROM NOTICE 
     WHERE HIT>=15 
     AND WRITER_ID='sjpark';

    --서브쿼리 쓸 경우
    SELECT TITLE, WRITER_ID,HIT
    FROM(SELECT * FROM notice WHERE WRITER_ID ='sjpark') X
    WHERE X.HIT>=15
    ORDER BY HIT DESC;

        ----------------------------------------------------




3. WHERE 절에서 사용되는 서브쿼리(중첩서브쿼리)

    -- 서브쿼리 결과에 따라

    - 단일행 서브쿼리
      서브쿼리의 결과가 1개의 행만 나오는 것
      단일행 서브쿼리 연산자 : =, <, >, <>

    - 다중행 서브쿼리(Multiple-Row Subquery)
      서브쿼리의 결과가 2건 이상 출력되는 경우
      다중행 서브쿼리 연산자 : IN


    > NOTICE TALBE로부터 가입인사 관련 게시글 중 HIT 수가
      100 이상인 게시글의 작성자와 TITLE, HIT 수를 조회하시오
        ----------------------------------------------------
        SELECT TITLE, WRITER_ID, HIT
        FROM NOTICE
        WHERE TITLE LIKE '%가입인사%' AND HIT >= 100;

      SELECT TITLE , WRITER_ID, HIT SELECT
      FROM NOTICE
      WHERE WRTIER_ID IN 
      (
        SELECT WRITER_ID 
        FROM NOTICE 
        WHERE TITLE LIKE '%가입인사%'
        AND HIT >=100 );




        ----------------------------------------------------


    > EMPLOYEES 테이블에서 개발부서(Development) 소속인 직원들을 조회하시오
        ----------------------------------------------------
        
        
        SELECT * FROM EMPLOYEES LIMIT 5;
        SELECT * FROM DEPT_EMP LIMIT 5;
        SELECT * FROM DEPARTMENTS;

        SELECT * 
        FROM employees a
        WHERE a.EMP_NO IN
        (
          SELECT  B.emp_no
          FROM dept_emp B
          WHERE B.dept_no ='d005'
        )
        LIMIT 100;




        ---------------------------------------------------- 


    > CITY 테이블에서 인구가 가장 많은 도시의 정보를 조회하시오
        ----------------------------------------------------
        SELECT MAX(POPULATION) FROM CITY;

        SELECT *
        FROM CITY ADDWHRER A.POPULATION =
        (
          SELECT MAX(POPULATION) FROM city
        );

        SELECT *
        FROM CITY A
        WHERE A.POPULATION >= 
         ( 
          SELECT ROUND(AVG(POPULATION)) 
          FROM CITY
          );


        ----------------------------------------------------         