# Repositorio de Teoría Política

Aplicación web desarrollada con Ruby on Rails que funciona como repositorio colaborativo de teoría política: permite gestionar **temas** y **conceptos**, enlazar conceptos entre sí, buscar contenidos y descargar documentos.

## Stack

- **Ruby** 3.2.2
- **Rails** 8.1
- **PostgreSQL** (base de datos)
- **Devise** (autenticación y sesiones)
- **Hotwire** (Turbo + Stimulus), Importmap
- **Docker** (opcional, para entorno contenedorizado)

## Requisitos

- Ruby 3.2.2 (se recomienda gestionarlo con [rbenv](https://github.com/rbenv/rbenv) o [RVM](https://rvm.io/))
- PostgreSQL corriendo localmente
- Bundler (`gem install bundler`)

## Puesta en marcha

1. Instalar dependencias:

   ```bash
   bundle install
   ```

2. Configurar la base de datos en `config/database.yml` según tu entorno local.

3. Crear, migrar y poblar la base de datos:

   ```bash
   rails db:setup
   # o, alternativamente:
   rails db:create db:migrate db:seed
   ```

4. Generar una clave de credenciales nueva (el archivo `config/master.key` no se incluye en el repositorio):

   ```bash
   EDITOR="code --wait" bin/rails credentials:edit
   ```

   Este comando crea un nuevo `config/master.key` y un `credentials.yml.enc` vacío si no existen.

5. Levantar el servidor:

   ```bash
   bin/rails server
   ```

   La aplicación estará disponible en `http://localhost:3000`.

### Con Docker

El proyecto incluye un `Dockerfile` para construir una imagen de la aplicación:

```bash
docker build -t repositorio_teoria_politica .
docker run -p 3000:3000 repositorio_teoria_politica
```

## Tests

```bash
bin/rails test
```

## Estructura

- `app/models` — modelos (usuarios, temas, conceptos, enlaces)
- `app/controllers` — controladores REST
- `test/` — suite de tests de Rails
- `db/migrate` — migraciones de base de datos

## Licencia

Este proyecto se distribuye bajo la **GNU General Public License v3.0**.
Podés leer el texto completo en el archivo [`LICENSE`](LICENSE) o en
<https://www.gnu.org/licenses/gpl-3.0>.

Copyright (C) 2026 pinerocarlosmanuel

Este programa es software libre: puede redistribuirse y/o modificarse bajo los
términos de la GNU General Public License publicada por la Free Software
Foundation, en su versión 3 (o cualquier otra versión posterior si así se
decidiera). Este programa se distribuye con la esperanza de que sea útil, pero
SIN NINGUNA GARANTÍA; sin siquiera la garantía implícita de COMERCIABILIDAD o
APTITUD PARA UN PROPÓSITO PARTICULAR. Ver la GNU General Public License para
más detalles.
