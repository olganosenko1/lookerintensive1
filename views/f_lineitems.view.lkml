view: f_lineitems {
  sql_table_name: "DATA_MART"."F_LINEITEMS"
    ;;

  dimension: l_availqty {
    type: number
    sql: ${TABLE}."L_AVAILQTY" ;;
  }

  dimension: l_clerk {
    type: string
    sql: ${TABLE}."L_CLERK" ;;
  }

  dimension: l_commitdatekey {
    type: number
    sql: ${TABLE}."L_COMMITDATEKEY" ;;
  }

  dimension: l_custkey {
    type: number
    sql: ${TABLE}."L_CUSTKEY" ;;
  }

  dimension: l_discount {
    type: number
    sql: ${TABLE}."L_DISCOUNT" ;;
  }

  dimension: l_extendedprice {
    type: number
    sql: ${TABLE}."L_EXTENDEDPRICE" ;;
  }

  dimension: l_linenumber {
    type: number
    sql: ${TABLE}."L_LINENUMBER" ;;
  }

  dimension: l_orderdatekey {
    type: number
    sql: ${TABLE}."L_ORDERDATEKEY" ;;
  }

  dimension: l_orderkey {
    type: number
    primary_key: yes
    sql: ${TABLE}."L_ORDERKEY" ;;
  }

  dimension: l_orderpriority {
    type: string
    sql: ${TABLE}."L_ORDERPRIORITY" ;;
  }

  dimension: l_orderstatus {
    type: string
    sql: ${TABLE}."L_ORDERSTATUS" ;;
  }

  dimension: l_partkey {
    type: number
    sql: ${TABLE}."L_PARTKEY" ;;
  }

  dimension: l_quantity {
    type: number
    sql: ${TABLE}."L_QUANTITY" ;;
  }

  dimension: l_receiptdatekey {
    type: number
    sql: ${TABLE}."L_RECEIPTDATEKEY" ;;
  }

  dimension: l_returnflag {
    type: string
    sql: ${TABLE}."L_RETURNFLAG" ;;
  }

  dimension: l_shipdatekey {
    type: number
    sql: ${TABLE}."L_SHIPDATEKEY" ;;
  }

  dimension: l_shipinstruct {
    type: string
    sql: ${TABLE}."L_SHIPINSTRUCT" ;;
  }

  dimension: l_shipmode {
    type: string
    sql: ${TABLE}."L_SHIPMODE" ;;
  }

  dimension: l_shippriority {
    type: number
    sql: ${TABLE}."L_SHIPPRIORITY" ;;
  }

  dimension: l_suppkey {
    type: number
    sql: ${TABLE}."L_SUPPKEY" ;;
  }

  dimension: l_supplycost {
    type: number
    sql: ${TABLE}."L_SUPPLYCOST" ;;
  }

  dimension: l_tax {
    type: number
    sql: ${TABLE}."L_TAX" ;;
  }

  dimension: l_totalprice {
    type: number
    sql: ${TABLE}."L_TOTALPRICE" ;;
  }

  dimension: supplier_link {
    label: "Google link to supplier web page"
    type: string
    sql: ${TABLE}.'S_NAME' ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://www.google.com/favicon.ico"
    }
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: TotalSalePrice  {
    label: "Total Sale Price"
    description: "Total sales from items sold"
    type: sum
    sql: ${l_extendedprice} ;;
    value_format_name: usd
  }

  measure: AverageSalePrice {
    label: "Average Sale Price"
    description: "Average sale price of items sold"
    type:  average
    sql: ${l_extendedprice} ;;
    value_format_name: usd
  }

  measure: CumulativeTotalSales {
    label: "Cumulative Total Sales"
    description: "Cumulative total sales from items sold (also known as a running total)"
    type: running_total
    sql: ${l_extendedprice} ;;
    value_format_name: usd
  }

  measure: SalesByAirMode {
    label: "Total Sale Price Shipped By Air"
    description: "Total sales of items shipped by air"
    type:  sum
    sql: ${l_extendedprice} ;;
    filters: [l_shipmode: "AIR"]
    value_format_name: usd
  }

  measure: TotalRussiaSales {
    label: "Total Russia Sales"
    description: "Total sales by customers from Russia"
    type: sum
    sql: ${l_extendedprice} ;;
    filters: [d_customer.c_nation: "RUSSIA"]
    value_format_name: usd
  }

  measure: GrossRevenue {
    label: "Total Gross Revenue"
    description: "Total price of completed sales"
    type: sum
    sql: ${l_totalprice} ;;
    filters: [l_orderstatus: "F"]
    value_format_name: usd
  }

  measure: TotalCost {
    label: "Total Cost"
    type:  sum
    sql: ${l_supplycost} ;;
    value_format_name: usd
  }

  measure: GrossMargin {
    label: "Total Gross Margin Amount"
    type: number
    sql: ${GrossRevenue}-${TotalCost} ;;
    value_format_name: usd
  }

  measure: GrossMarginDrill {
    label: "Total Gross Margin Amount Drill"
    type: number
    drill_fields: [d_supplier.s_name, d_supplier.suppliers_tiers, d_supplier.s_nation, d_supplier.s_region]
    sql: ${GrossRevenue}-${TotalCost} ;;
    value_format_name: usd
  }

  measure: GrossMarginPercentage {
    label: "Gross Margin Percentage"
    description: "Total Gross Margin Amount/Total Gross Revenue"
    sql: (1.0*${GrossMargin})/NULLIF(${GrossRevenue},0) ;;
    value_format_name: percent_1
  }

  dimension: ItemIsReturned {
    type: yesno
    sql: ${l_returnflag}='R' ;;
  }
  measure: ItemsReturned {
    label: "Number of Items Returned"
    description: "Number of items that were returned by dissatisfied customers"
    type: sum
    sql: ${l_quantity} ;;
    filters: [ItemIsReturned: "yes"]
  }

  measure: ItemsSold {
    label: "Total Number of Items Sold"
    description: "Number of items that were sold"
    type: sum
    sql: ${l_quantity} ;;
    value_format_name: id
  }

  measure: ReturnRate {
    label: "Item Return Rate"
    description: "Number Of Items Returned / Total Number Of Items Sold"
    sql: ${ItemIsReturned}/(NULLIF(${ItemsSold},0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: CustomerCount {
    label: "Customer Count"
    description: "Distinct count of customers made a purchase"
    sql: ${l_custkey} ;;
    type: count_distinct
  }

  measure: SpendPerCustomer {
    label: "Average Spend per Customer"
    description: "Total Sale Price / Total Number of Customers"
    sql: ${TotalSalePrice}/(NULLIF(${CustomerCount},0);;
    type: number
    value_format_name: usd
  }


}
