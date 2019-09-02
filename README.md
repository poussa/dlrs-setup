# dlrs-setup
Deep Learning Reference Stack configurations and deployments

## Initalize environment

```bash
source ./env.sh
```

## OpenVINO Model Server (ovms) setup

### Init

```bash
ovms_setup
```

### Download Open Model Zoo models

```bash
model_zoo_download
```

### Convert Open Model Zoo models to OpenVINO IR format


```bash
model_zoo_convert
```

### Run OpenVINO model server container

Single model

```bash
ovms_start
```

Multiple models

```bash
ovms_start_with_config
```


## Deep Learning Reference Stack setup

TBD