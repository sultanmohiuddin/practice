-- ============================================================
-- Orders Reports SQL Extraction
-- Extracted from Oracle Reports RDF Binary Files
-- Source: Orders-Packaging\Orders_Reports\
-- ============================================================


-- ============================================================
-- FILE: HOMS_RO_Approval_LeadTime.rdf
-- ============================================================
SELECT A.TRANMST_PK,
       A.CUST_ID,
       CUST_NAME,
       DECODE(A.RO_TYPE, 'T', 'TRO', 'C', 'CRO') RO_TYPE,
       B.TRANDTL_PK,
       B.TRO_NO RO_NO,
       NDL_DESC,
       DECODE(TRO_TYPE, ...) TRO_TYPE_DESC,
       C.CONF_DATE,
       B.LOAD_DATE,
       B.MTRLAVAIL_DATE MTRL_DATE,
       D.SEG_CODE,
       D.SEG_DESC,
       D.QTY,
       A.PRODCATG_ID,
       ABS(D.QTY) SIGN_QTY,
       ABS(D.MC_DAYS) SIGN_MCDAYS
FROM   HOMS_TRO_MST A,
       HOMS_TRO_DTL B,
       (SELECT * FROM HOMS_TRO_AUTH WHERE RCV_YN IN ('Y','A')) C,
       (SELECT /* VW_RO_TRANS grouped */ ...) D
WHERE  A.TRANMST_PK = B.TRANMSTPK_FK
AND    B.TRANDTL_PK = C.TRANDTLPK_FK(+)
-- parameters
ORDER BY 2, 4, 11;


-- ============================================================
-- FILE: HOMS_RO_LEAD_TIME_SUMMARY.rdf  (Q_1)
-- ============================================================
-- Same structure as HOMS_RO_Approval_LeadTime but ORDER BY CUST_NAME
SELECT A.TRANMST_PK,
       A.CUST_ID,
       CUST_NAME,
       DECODE(A.RO_TYPE, 'T', 'TRO', 'C', 'CRO') RO_TYPE,
       B.TRANDTL_PK,
       B.TRO_NO RO_NO,
       NDL_DESC,
       C.AUTH_DATE,
       C.CONF_DATE,
       B.PKGAVAIL_DATE,
       B.EXP_DATE,
       B.LOAD_DATE,
       B.MTRLAVAIL_DATE MTRL_DATE,
       D.SEG_CODE,
       D.SEG_DESC,
       D.QTY,
       D.MC_DAYS,
       A.PRODCATG_ID,
       ABS(D.QTY) SIGN_QTY,
       ABS(D.MC_DAYS) SIGN_MCDAYS
FROM   HOMS_TRO_MST A,
       HOMS_TRO_DTL B,
       (SELECT * FROM HOMS_TRO_AUTH WHERE RCV_YN IN ('Y','A','N')) C,
       (SELECT /* VW_RO_TRANS grouped */ ...) D
WHERE  A.TRANMST_PK = B.TRANMSTPK_FK
AND    B.TRANDTL_PK = C.TRANDTLPK_FK(+)
ORDER BY CUST_NAME;


-- ============================================================
-- FILE: HOMS_RO_LEAD_TIME_SUMMARY.rdf  (Q_2 - TRO vs CRO averaging)
-- ============================================================
-- Complex TRO vs CRO averaging aggregation from HOMS_TRO_MST/DTL/AUTH/TRANS


-- ============================================================
-- FILE: HOMS_SALESORDER_DETAIL.rdf
-- ============================================================
SELECT rownum rno, a.*
FROM (
    SELECT B.LOAD_DATE,
           B.SHIP_DATE,
           -- [other columns]
    FROM   HOMS_SALESORDER_MST A,
           -- [other tables]
    ORDER BY B.LOAD_DATE, C.PS_CODE
) a;


-- ============================================================
-- FILE: HOMS_TRO_Dtl.rdf  (Q_1)
-- ============================================================
SELECT a.tro_no,
       -- [other columns]
FROM   homs_tro_mst a,
       homs_tro_dtl b,
       homs_tro_proxy c,
       vw_ndls_desc d,
       fr_pxitem_mst e,
       vw_customer f,
       fr_krgs g
WHERE  -- [join conditions and parameters]
;


-- ============================================================
-- FILE: HOMS_TRO_Dtl.rdf  (Q_2)
-- ============================================================
SELECT ro_no,
       rodtl_no,
       -- [other columns]
FROM   vw_ro_trans s
WHERE  rodtl_no = NVL(:tro, rodtl_no)
GROUP BY -- [columns]
;


-- ============================================================
-- FILE: HOMS_TRO_Sub_Dtl.rdf
-- ============================================================
SELECT ro_no,
       rodtl_no,
       pxitem_fk,
       -- [other columns]
FROM   vw_ro_trans s
WHERE  rodtl_no = :p_rodtl
AND    pxitem_fk = :p_pxfk
GROUP BY -- [columns]
ORDER BY 3, 8;


-- ============================================================
-- FILE: HOMS_TROMRP_COMPARISON.rdf  (CS_1 Summary - WHERE :P_REP='S')
-- ============================================================
-- Complex UNION ALL from HOMS_TRO_TRANS, HOMS_TRO_DTL, HOMS_TRO_MST,
-- SMPL_PLANYARN_MASTER, EBS.COMBINATIONS, PRD_PAIR_DESC,
-- PRD.PRD_PAIRYARNS_MASTER, SMPL.INV_MASTER_TEST, SMPL_BSCODE_MST,
-- HOMS_ORDERDEL_DTL, HOMS_ORDERDEL_MST, HOMS_SALESORDER_MST
-- WHERE :P_REP = 'S'


-- ============================================================
-- FILE: HOMS_TROMRP_COMPARISON.rdf  (CS_1 Detail - WHERE :P_REP='D')
-- ============================================================
-- Same tables as Summary section but WHERE :P_REP = 'D'


-- ============================================================
-- FILE: HOMS_TROMRP_COMPARISON.rdf  (CS_12 Category FNSH rollup)
-- ============================================================
-- UNION ALL from same tables with FNSH category rollup


-- ============================================================
-- FILE: PRD_Order_Sheet_X_HOMS.rdf
-- ============================================================
SELECT SM.ORD_NOTES,
       SM.ORD_TYPE,
       SM.CUST_ID,
       CM.CUST_ORD_NO,
       CM.CUST_ORD_DATE,
       OM.DEL_NO,
       OM.LOAD_DATE,
       OD.BS_TRANMSTPK_FK,
       OD.DZNS,
       SD.PS_TRANMSTPK_FK,
       SD.REQ_QTY,
       SD.REQ_UOM,
       SD.SELL_UOM,
       SD.LINE_ITEM,
       SD.SITE_ID,
       OM.CRTN_RMRKS,
       SM.ORD_NO,
       SM.STATUS,
       sd.trandtl_pk,
       sd.shipment_mode,
       S1.STYLE_DESC,
       S2.ART_DESC,
       S4.CLR_DESC,
       S3.SIZE_DESC
FROM   HOMS_ORDERDEL_DTL OD,
       HOMS_ORDERDEL_MST OM,
       HOMS_SALESORDER_DTL SD,
       HOMS_SALESORDER_MST SM,
       HOMS_CUSTORD_MST CM,
       SMPL_PSCODE_MST SP,
       SMPL_STYLE_MST S1,
       SMPL_ARTICLE_MST S2,
       SMPL_SIZE_MST S3,
       SMPL_COLOR_MST S4
WHERE  -- [join conditions]
AND    SM.ord_no = :ord
AND    OM.DEL_NO = :del;


-- ============================================================
-- FILE: PRD_RO_Balance.rdf
-- ============================================================
SELECT A.TRANMST_PK,
       A.CUST_ID,
       CUST_NAME,
       B.TRANDTL_PK,
       B.TRO_NO RO_NO,
       NDL_DESC,
       DECODE(RO_TYPE, ...) RO_TYPE_DESC,
       DECODE(TRO_TYPE, ...) TRO_TYPE_DESC,
       A.RO_TYPE RTYP,
       C.AUTH_DATE,
       C.CONF_DATE,
       B.PKGAVAIL_DATE,
       B.EXP_DATE,
       B.LOAD_DATE,
       B.MTRLAVAIL_DATE MTRL_DATE,
       D.SEG_CODE,
       D.SEG_DESC,
       D.QTY,
       D.MC_DAYS,
       A.PRODCATG_ID,
       ABS(D.QTY) SIGN_QTY,
       ABS(D.MC_DAYS) SIGN_MCDAYS
FROM   HOMS_TRO_MST A,
       HOMS_TRO_DTL B,
       (SELECT * FROM HOMS_TRO_AUTH WHERE RCV_YN IN ('Y','A')) C,
       (SELECT /* VW_RO_TRANS grouped */ ...) D
WHERE  -- [join conditions]
AND    &P_SPOT_ORD_QRY
AND    B.TRO_NO = NVL(:P_TRONO, B.TRO_NO)
AND    B.NDL_ID = NVL(:P_NDLID, B.NDL_ID)
AND    &MY_QRY
UNION ALL
-- second part (DRIVEN='Y', NOT EXISTS HOMS_TRO_AUTH)
ORDER BY 2, 5, 16;


-- ============================================================
-- FILE: PRD_RO_MRP_Balance.rdf
-- ============================================================
-- Complex UNION ALL from:
-- VW_RO_TRANS_BAL_FR, HOMS_TRO_DTL,
-- (subquery B from HOMS_TRO_MST via HOMS_TRO_DTL),
-- SMPL_PLANYARN_MASTER C, SMPL.INV_MASTER_TEST D
-- Parameter: :TRO
-- Uses PRD.GET_CUST_PRODUCT_WASTE function


-- ============================================================
-- FILE: PRD_Shipment_Order_status.rdf
-- ============================================================
SELECT a.ord_type,
       a.cust_id || '-' || cu.name cust_id,
       a.ord_no,
       D.DEL_NO,
       C.LOAD_DATE,
       C.SHIP_DATE,
       D.CRTN_CODE,
       (SELECT /* CUST_ORD subquery */ ...) CUST_ORD,
       D.CRTN_SHIP_MARK,
       CS.CS_CODE,
       GET_STYLE_NO(...),
       (SELECT /* REGN subquery */ ...) REGN,
       D.CRTN_QTY REQ_QTY,
       -- crtn dimensions
       VOLUME CBM,
       FGS_REC,
       FGS_REC_DZN,
       SHP_CRTN,
       SHIP_DZN,
       QA_PASS_OBL,
       RSRV_CRTN,
       RSRV_DZN,
       NQC_STATUS
FROM   homs_salesorder_mst a,
       homs_orderdel_mst c,
       prd_crtn_dtl d,
       SMPL_CSCODE_MST CS,
       vw_customer cu
WHERE  a.ord_type = 'SHIPMENT ORDER'
AND    -- [parameters]
ORDER BY C.LOAD_DATE, a.cust_id;


-- ============================================================
-- FILE: PRD_TRO_Maturity.rdf
-- ============================================================
SELECT A.TRANMST_PK,
       TO_NUMBER(A.CUST_ID),
       CUST_NAME,
       B.TRANDTL_PK,
       B.TRO_NO RO_NO,
       NDL_DESC,
       RO_STAT,
       DECODE(RO_TYPE, ...) RO_TYPE_DESC,
       A.RO_TYPE RTYP,
       C.AUTH_DATE,
       C.CONF_DATE,
       B.EXP_DATE,
       B.LOAD_DATE,
       B.MTRLAVAIL_DATE MTRL_DATE,
       Y.PXITEM_FK,
       PROXY,
       Y.FORECASTED,
       D.SEG_CODE,
       D.SEG_DESC,
       D.QTY,
       D.MC_DAYS,
       ABS(QTY / MCDAYS),
       CONF_QTY,
       CONF_MCDAYS,
       LINK_QTY,
       LINK_MCDAYS
FROM   HOMS_TRO_MST A,
       HOMS_TRO_DTL B,
       HOMS_TRO_PROXY Y,
       (SELECT * FROM HOMS_TRO_AUTH) C,
       (SELECT /* VW_RO_TRANS grouped by PRX */ ...) D
WHERE  A.RO_TYPE = 'T'
AND    B.STATUS_ID <> 12
AND    -- [join and parameter conditions]
UNION ALL
-- second part (DRIVEN='Y')
ORDER BY 2, 6, 13, 15, 18;


-- ============================================================
-- FILE: SALESORDER.rdf
-- ============================================================
SELECT sm.tranmst_pk,
       sm.ord_type,
       sm.CUST_ID,
       cm.CUST_ORD_NO,
       cm.CUST_ORD_DATE,
       sm.ORD_NO,
       sm.CRNCY_ID,
       sm.STATUS,
       sm.CUST_NOTES,
       sm.ORD_NOTES,
       sd.PS_TRANMSTPK_FK,
       sd.REQ_QTY,
       sd.REQ_UOM,
       sd.SELL_UOM,
       sd.DZNS,
       sd.RATE,
       sd.SITE_ID,
       sd.PAY_TERM,
       sd.SHIP_TERM,
       sd.LOAD_DATE,
       sd.SHIP_DATE,
       UPPER(sd.PACK_RMRKS) PACK_RMRKS,
       sd.FOB_DIFF,
       sd.amount,
       sd.trandtl_pk
FROM   HOMS_SALESORDER_DTL SD,
       HOMS_SALESORDER_MST SM,
       HOMS_CUSTORD_MST CM
WHERE  (SM.TRANMST_PK = SD.TRANMSTPK_FK)
AND    (CM.TRANMST_PK(+) = SM.CUST_ORD_ID)
AND    (SM.TRANMST_PK = :tranmst_pk);
-- Plus sub-queries for SAMPLES, UPC, COMP, AGENTS


-- ============================================================
-- FILE: SHIPMENT_ORDER_DETAIL.RDF
-- ============================================================
SELECT cust_id,
       cust_name,
       shipment_order,
       shipment_del,
       shipment_carton,
       cust_ord_id PO_id,
       CUST_ORD_NO "PO#",
       load_date,
       MAX(cs) CS,
       COUNT(crtno) no_of_cartons,
       MAX(ship_ord_qty) ship_ord_qty,
       MAX(ship_ord_dzn) ship_ord_dzn,
       stts,
       pltno,
       cost_code,
       mts_order,
       mts_del,
       mts_carton,
       crtn_ship_mark,
       GET_ORDERDEL_CUSTPO(mts_order, mts_del) "mts_po#"
FROM (
    SELECT e.cust_id,
           g.name cust_name,
           crtno,
           stts,
           ordno shipment_order,
           dlvno shipment_del,
           crtcode shipment_carton,
           D.cust_ord_id,
           E.CUST_ORD_NO,
           crtn_qty ship_ord_qty,
           inr_qty * inr_qty ship_ord_dzn,
           pltno,
           owner cost_code,
           o_ordno mts_order,
           C.CS_CODE CS,
           f.load_date,
           o_dlvno mts_del,
           o_crtcode mts_carton,
           b.crtn_ship_mark
    FROM   crtstatus a,
           prd_crtn_dtl b,
           SMPL_CSCODE_MST c,
           prd_crtn_asort d,
           HOMS_CUSTORD_MST e,
           homs_orderdel_mst f,
           homs_salesorder_mst k,
           vw_customer g
    WHERE  ordno <> o_ordno
    AND    a.ordno = b.ord_no
    AND    a.dlvno = b.del_no
    AND    B.ORD_NO = D.ORD_NO
    AND    k.TRANMST_PK = f.TRANMSTPK_FK
    AND    TRIM(b.crtn_code) = TRIM(d.carton_code)
    AND    TRIM(a.crtcode) = TRIM(b.crtn_code)
    AND    B.CS_TRANMSTPK_FK = c.tranmst_pk
    AND    D.CUST_ORD_ID = E.TRANMST_PK
    AND    b.ord_no = f.ord_no
    AND    b.del_no = f.del_no
    AND    e.cust_id = g.cust_id
    AND    e.cust_id = NVL(:P_CUSTID, e.cust_id)
    AND    a.ordno = NVL(:P_ORDNO, a.ordno)
    AND    a.dlvno = NVL(:P_DELNO, a.dlvno)
    AND    k.rework_req = 'Y'
)
GROUP BY stts, shipment_order, shipment_del, shipment_carton, pltno,
         cost_code, mts_order, mts_del, mts_carton, crtn_ship_mark,
         cust_ord_id, cust_id, cust_name, CUST_ORD_NO, load_date;


-- ============================================================
-- FILE: HMS_ROAprovLTime_X.rdf
-- ============================================================
SELECT   A.TRANMST_PK,
         A.CUST_ID,
         INITCAP((SELECT CUST_ID || ' - ' || NAME FROM VW_CUSTOMER WHERE CUST_ID = A.CUST_ID)) CUST_NAME,
         DECODE(A.RO_TYPE, 'T', 'TRO', 'C', 'CRO') RO_TYPE,
         B.TRANDTL_PK,
         B.TRO_NO AS RO_NO,
         C.AUTH_DATE,
         INITCAP((SELECT STATUS_DESC FROM HOMS_ROSTATUS_MST WHERE STATUS_ID = B.STATUS_ID)) RO_STATUS,
         B.EXP_DATE RO_Expiry_Date,
         (SELECT ' ' || NDL_DESC FROM VW_NDLS_DESC WHERE NDL_ID = B.NDL_ID) NDL_DESC,
         C.CONF_DATE MP_CONF_DATE,
         B.LOAD_DATE,
         B.MTRL_TRAN_DATE MRP_CONF_DATE,
         B.MTRLAVAIL_DATE MRP_DATE,
         B.QTY,
         d.ord_no,
         d.del_no,
         d.auth_date ord_auth_date,
         TRO_WISE_MCDAYS_CALC_FUN(B.TRO_NO) MC_DAYS,
         ROUND(B.MTRL_TRAN_DATE - C.AUTH_DATE, 2) MTRL_LT,
         ROUND(C.CONF_DATE - B.MTRL_TRAN_DATE, 2) MP_LT,
         A.PRODCATG_ID
FROM     HOMS_TRO_MST A,
         HOMS_TRO_DTL B,
         (SELECT TRANDTLPK_FK, AUTH_DATE, RCV_DATE CONF_DATE
          FROM   HOMS_TRO_AUTH
          WHERE  RCV_YN IN ('Y', 'A', 'N')) C,
         (SELECT DISTINCT D1.TRANDTLPK_FK, f1.f_load_date, f1.ord_no, f1.del_no, g1.auth_date
          FROM   PRD.HOMS_TRO_IOLINKS a1,
                 homs_orderdel_dtl b1,
                 homs_tro_proxysub c1,
                 HOMS_TRO_PROXY d1,
                 homs_orderdel_mst f1,
                 prd_order_auth g1
          WHERE  A1.IODTL_TRANMSTPK_FK = b1.tranmstpk_fk
          AND    A1.IODTL_TRANDTLPK_FK = B1.TRANDTLPK_FK
          AND    A1.IODTL_BS_TRANMSTPK_FK = B1.BS_TRANMSTPK_FK
          AND    A1.PRXYSUB_TRANSUBPK_FK = C1.TRANSUB_PK
          AND    C1.PRXY_TRANDTLPK_FK = D1.TRANDTL_PK
          AND    B1.TRANMSTPK_FK = F1.TRANMST_PK) d
WHERE    A.TRANMST_PK = B.TRANMSTPK_FK
AND      B.TRANDTL_PK = C.TRANDTLPK_FK
AND      A.CUST_ID = NVL(:P_CUST_ID, A.CUST_ID)
AND      B.TRANDTL_PK = d.TRANDTLPK_FK
AND      A.PRODCATG_ID = NVL(:P_PROD_CATG, A.PRODCATG_ID)
AND      TRUNC(B.LOAD_DATE) BETWEEN NVL(:P_LOAD_DATE_S, B.LOAD_DATE) AND NVL(:P_LOAD_DATE_E, B.LOAD_DATE)
AND      TRUNC(C.AUTH_DATE) BETWEEN NVL(:P_AUTH_DATE_S, C.AUTH_DATE) AND NVL(:P_AUTH_DATE_E, C.AUTH_DATE)
AND      TRUNC(C.CONF_DATE) BETWEEN NVL(:P_CONF_DATE_S, C.CONF_DATE) AND NVL(:P_CONF_DATE_E, C.CONF_DATE)
AND      TRUNC(B.MTRL_TRAN_DATE) BETWEEN NVL(:P_MRP_DATE_S, B.MTRL_TRAN_DATE) AND NVL(:P_MRP_DATE_E, B.MTRL_TRAN_DATE)
AND      B.TRO_NO = NVL(:P_TRONO, B.TRO_NO)
AND      B.NDL_ID = NVL(:P_NDLID, B.NDL_ID)
AND      A.RO_TYPE = 'C'
ORDER BY 2, 4, 11;


-- ============================================================
-- FILE: PRD_RoApproved_Detail.rdf
-- (Two-part UNION ALL)
-- ============================================================
-- Part 1 and Part 2: UNION ALL involving
-- HOMS_TRO_DTL, HOMS_TRO_AUTH, HOMS_TRO_MST, HOMS_TRO_PROXY, HOMS_TRO_ADJ
-- Parameters: :P_AUTH_DATE_F, :P_AUTH_DATE_T, :P_SPOT_ORD
-- Selects: authorization date, confirm date, customer, RO status, lead times, delays


-- ============================================================
-- FILE: PRD_RO_MRP_Balance_Detail.rdf
-- (6-part UNION ALL)
-- ============================================================
-- 1. CRO Yarn:
--    FROM VW_RO_TRANS_BAL_FR, HOMS_TRO_DTL, VW_SMPL_REF_NO,
--         SMPL_PLANYARN_MASTER, SMPL.INV_MASTER_TEST, FR_PXITEM_MST, FR_PXITEM_DTL
--    WHERE RO_TYPE='C' AND RODTL_NO=:TRO
-- 2. CRO Add-operations items
-- 3. CRO Dyes & Chemicals:
--    FROM VW_RO_TRANS_BAL_FR, SMPL_PLAN_DTL, VW_BOTH_RECP_CHMCL_DTL
-- 4. TRO Yarn:
--    FROM VW_RO_TRANS_BAL_FR, HOMS_TRO_DTL WHERE RO_TYPE='T'
-- 5. TRO Add-operations items
-- 6. TRO Dyes & Chemicals


-- ============================================================
-- FILE: PRD_RO_Summary.rdf
-- (Two-part UNION ALL)
-- ============================================================
-- FROM HOMS_TRO_MST, HOMS_TRO_DTL, HOMS_TRO_AUTH, HOMS_TRO_TRANS
-- WITH &MY_QRY &MP_REJ conditions


-- ============================================================
-- FILE: PRD_RO_Detail.rdf
-- ============================================================
-- WHERE :P_TYPE <> 'C' section:
SELECT -- [TRO detail columns]
FROM   HOMS_TRO_MST      A,
       HOMS_TRO_DTL      B,
       HOMS_TRO_PROXY    C,
       HOMS_TRO_PROXYSUB D
WHERE  A.TRANMST_PK = B.TRANMSTPK_FK
AND    A.ACTIVE = 'Y'
AND    :P_TYPE <> 'C'
AND    B.TRANDTL_PK = C.TRANDTLPK_FK
AND    C.TRANDTL_PK = D.PRXY_TRANDTLPK_FK(+)
AND    A.CUST_ID = NVL(:P_CUST_ID, A.CUST_ID)
AND    A.RO_TYPE = NVL(:P_RO_TYPE, A.RO_TYPE)
AND    A.PRODCATG_ID = NVL(:P_PROD_CATG, A.PRODCATG_ID)
AND    B.STATUS_ID = NVL(:P_STATUSID, B.STATUS_ID)
AND    TRUNC(A.TRAN_DATE) BETWEEN NVL(:P_FROM_DATE, TRUNC(A.TRAN_DATE)) AND NVL(:P_TO_DATE, TRUNC(A.TRAN_DATE))
AND    TRUNC(B.LOAD_DATE) BETWEEN NVL(:P_LOAD_DATE_S, B.LOAD_DATE) AND NVL(:P_LOAD_DATE_E, B.LOAD_DATE)
AND    B.NDL_ID = NVL(:P_NDLID, B.NDL_ID)
AND    a.SPOT_ORDER_YN = NVL(:p_so, a.SPOT_ORDER_YN)
ORDER BY B.TRO_NO;


-- ============================================================
-- FILES NOT EXTRACTABLE (binary/HTML/compressed):
-- PRD_RO_Specs_Add_Opns.rdf  - HTML/JSP web template, no SQL
-- PRD_Shipment_Status_R.rdf  - Compressed/unreadable binary
-- PRD_RO_MRP_Balance_SUM.rdf - JSP/web template content
-- PRD_RO_Detail_VAR.rdf      - HTML/JavaScript web navigator template
-- ============================================================
