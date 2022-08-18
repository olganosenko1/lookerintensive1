view: d_supplier {
  sql_table_name: "DATA_MART"."D_SUPPLIER"
    ;;

  dimension: s_acctbal {
    type: number
    sql: ${TABLE}."S_ACCTBAL" ;;
  }

  dimension: s_address {
    type: string
    sql: ${TABLE}."S_ADDRESS" ;;
  }

  dimension: s_name {
    type: string
    sql: ${TABLE}."S_NAME" ;;
  }

  dimension: s_nation {
    type: string
    sql: ${TABLE}."S_NATION" ;;
  }

  dimension: s_phone {
    type: string
    sql: ${TABLE}."S_PHONE" ;;
  }

  dimension: s_region {
    type: string
    sql: ${TABLE}."S_REGION" ;;
  }

  dimension: s_suppkey {
    type: number
    primary_key: yes
    sql: ${TABLE}."S_SUPPKEY" ;;
  }
  dimension: SupplierGroup {
    label: "Cohort of suppliers"
    description: "Cohort of suppliers according to Account Balance"
    type: tier
    style:  integer
    tiers: [1,3001,5001,7001]
    sql: ${s_acctbal} ;;
  }

  dimension: supplier_link {
    label: "Google link to supplier web page"
    type: string
    sql: ${TABLE}."S_NAME" ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://www.google.com/favicon.ico"
    }
  }

  measure: count {
    type: count
    drill_fields: [s_name]
  }
}
