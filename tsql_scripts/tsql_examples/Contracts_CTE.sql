WITH Contracts_CTE (CtrCustomerID, NumberOfContracts)
AS (
    SELECT
        CUSTOMER_ID
        , COUNT(*)
    FROM contracts
    GROUP BY CUSTOMER_ID
)
 
SELECT AVG(NumberOfContracts) AS [Average]
FROM Contracts_CTE;