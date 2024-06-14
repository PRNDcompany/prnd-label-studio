# How to build and run
```bash
make build; make run
```
- If you want to change version or ports, please change values in [`.env`](.env) file.

# How to contribute label studio and ml backend
- Follow the instruction in [How to change label studio](prnd_label_studio/README.md)
- Follow the instruction in [How to change ml backend](prnd_label_studio_ml_backend/README.md)


# How to annotate data
- Access to `http://192.168.0.53:8082` (You can change port in [`.env`](.env) file)
- Create project and import data manually or using SDK
- Annotate data

## How to use ML backend (cvt-polygon-to-brush example)
- In project, go to `Settings` -> `Model` -> `Connect model`
- Fill the form:
  - Name: `cvt-polygon-to-brush` (or any name you want)
  - Backend URL: `http://cvt-polygon-to-brush:9090`
  (please use the same name and port as the ml-backend container in [`docker-compose.yml`](docker-compose.yml))
- Turn on `Interactive preannotation`
- Press `Validate and Save` and `Save` button
- Turn on `Auto-Annotation` in annotation page and change `Brush` to `Polygon` of `Auto-Detect`
- Start annotating data
