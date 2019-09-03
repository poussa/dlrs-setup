# dlrs-setup

OpenVINO model server and Deep Learning Reference Stack configurations and deployments

## Initalize environment

```bash
source ./env.sh
```

Assumes your source directory (git clone destination) is `$HOME/src`. If not, use the following.

```bash
export SRC_DIR=<path-to-src-dir>
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

Custom image

```bash
OVMS_IMAGE_NAME=ie-serving-py ovms_start_with_config
```

### Get model info

Get the model's input and output tensor names and shapes.

```bash
ovms_model_info
```

### Run Infrence

```bash
ovms_inference
```

## Deep Learning Reference Stack setup

TBD
