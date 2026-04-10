# SofaExchange Analytics

Pipeline analytique dbt pour SofaExchange, basé sur DuckDB.

## Setup

```bash
# Créer et activer un environnement virtuel
cd apps/analytics
python -m venv .venv
source .venv/bin/activate  # Windows : .venv\Scripts\activate

# Installer dbt avec l'adaptateur DuckDB
pip install dbt-duckdb

# Vérifier l'installation
dbt --version
```

## Commandes

```bash
# Charger les données sources (CSV → DuckDB)
dbt seed

# Construire tous les modèles
dbt run

# Lancer les tests de qualité
dbt test

# Explorer la documentation et la lignée des modèles
dbt docs generate && dbt docs serve
```

## Architecture

```
seeds/
  sofas.csv             → données brutes SofaExchange (29 annonces)
  cities.csv            → référentiel de villes (EN / FR / IT)

models/
  staging/
    stg_sofas           → nettoyage et typage des données sources
    stg_cities          → référentiel de villes avec noms multilingues
  intermediate/
    int_sofas_with_city → enrichissement des sofas avec les infos de ville
  marts/
    sofas_by_city       → nombre d'annonces et prix moyen par ville
    sofas_by_sofa_type  → répartition par type de sofa
```

## Données

29 annonces réparties dans 9 villes européennes.
Prix en euros. `has_free_wifi` : true/false.
