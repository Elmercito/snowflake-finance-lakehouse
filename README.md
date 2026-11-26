# Snowflake Financial Data Lakehouse (ELT & DataOps)

Pipeline de données financier automatisé de bout en bout reposant sur une architecture **Data Lakehouse (Medallion)** et une modélisation dimensionnelle en **Schéma en Étoile**. Ce projet extrait quotidiennement les données boursières de grandes institutions financières et technologiques nord-américaines, les transforme, valide leur qualité et alimente un environnement analytique prêt pour la décision.

---

## Architecture Technique

```text
[ API Yahoo Finance ] 
         │
         ▼  (Python : yfinance + Snowpark)
┌────────────────────────────────────────────────────────┐
│ SNOWFLAKE : FINANCE_LAKEHOUSE                          │
│                                                        │
│  1. BRONZE (Raw Layer)                                 │
│     └── STOCK_PRICES_RAW (Ingestion brute horodatée)   │
│            │                                           │
│            ▼  (dbt Core : Nettoyage & Dédoublonnage)   │
│  2. SILVER (Cleansed Layer)                            │
│     └── STG_STOCK_PRICES (Rendements journaliers LAG)  │
│            │                                           │
│            ▼  (dbt Core : Modélisation en Étoile)      │
│  3. GOLD (Analytics Data Mart)                         │
│     ├── DIM_STOCKS (Référentiel titres & secteurs)     │
│     ├── DIM_DATE   (Calendrier financier)              │
│     └── FACT_DAILY_MARKET (Mesures & clés étrangères)  │
└────────────────────────────────────────────────────────┘
         │
         ▼  (Qualité & Consommation)
  • dbt test (Validation unique, not_null, intégrité référentielle)
  • Jupyter Notebook (Analyse de corrélation & visualisations Pandas/Seaborn)
```

---

## Stack Technologique

* **Cloud Data Warehouse / Lakehouse :** Snowflake (Séparation stockage/calcul, gestion économique des entrepôts `AUTO_SUSPEND`)
* **Ingestion (Extract & Load) :** Python 3.11, `snowflake-snowpark-python`, `yfinance`, `pandas`
* **Transformation & Qualité (Transform) :** dbt Core (`dbt-snowflake`), SQL analytique (Window Functions `ROW_NUMBER`, `LAG`), tests de données automatisés
* **Modélisation :** Architecture Medallion (`BRONZE` / `SILVER` / `GOLD`) & Schéma en Étoile (`FACT` / `DIM`)
* **CI/CD & DataOps :** GitHub Actions (planification `cron` quotidienne après fermeture des marchés)
* **Sécurité :** Authentification par Programmatic Access Token (PAT), Network Policies Snowflake, gestion des secrets via `.env` et GitHub Secrets

---

## Structure du Dépôt

```text
snowflake-finance-lakehouse/
├── .github/workflows/
│   └── daily_elt.yml            # Pipeline CI/CD automatisé (Ingestion + dbt run + dbt test)
├── dbt_finance/                 # Projet dbt Core
│   ├── macros/                  # Personnalisation des schémas cibles
│   ├── models/
│   │   ├── silver/              # Déclaration des sources et nettoyage (stg_stock_prices)
│   │   └── gold/                # Schéma en étoile (dim_stocks, dim_date, fact_daily_market) + tests YAML
│   ├── dbt_project.yml
│   └── profiles.yml             # Configuration dynamique via variables d'environnement
├── notebooks/
│   └── financial_analysis.ipynb # Exploration de la couche GOLD, corrélations et graphiques
├── src/
│   └── ingest_stocks.py         # Extraction API et chargement vers Snowflake BRONZE
├── .gitignore                   # Exclusion des fichiers sensibles (.env) et artefacts locaux
└── requirements.txt             # Dépendances Python et dbt
```

---

##  Fonctionnalités Clés Implémentées

1. **Idempotence & Dédoublonnage :** Le pipeline peut être exécuté plusieurs fois par jour sans créer de doublons grâce au partitionnement analytique (`ROW_NUMBER() OVER (PARTITION BY TICKER, TRADE_DATE)`) dans la couche `SILVER`.
2. **Modélisation Dimensionnelle :** Séparation stricte entre les faits quantitatifs (`FACT_DAILY_MARKET`) et les attributs descriptifs (`DIM_STOCKS`, `DIM_DATE`) pour optimiser les requêtes BI par secteur, devise (`CAD`/`USD`) et trimestre.
3. **Tests de Qualité Automatisés (`dbt test`) :** Vérification systématique de l'unicité des clés, de l'absence de valeurs nulles sur les prix de clôture et de l'intégrité référentielle entre les faits et les dimensions.
4. **Sécurité Zero-Trust :** Aucun identifiant n'est stocké dans le code source ; les connexions locales s'appuient sur `python-dotenv` et l'exécution cloud utilise les coffres-forts **GitHub Secrets**.
