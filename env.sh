SRC_DIR=$HOME/src
DLDT_SRC_DIR=$SRC_DIR/dldt
OVMS_SRC_DIR=$SRC_DIR/OpenVINO-model-server
OVMS_IMAGE_NAME=intelaipg/openvino-model-server:latest
OVMS_MODEL_NAME=inception-resnet-v2-fp32
MODEL_ZOO_SRC_DIR=$SRC_DIR/open_model_zoo
MODEL_DIR=/opt/models
CACHE_DIR=/opt/cache

function model_zoo_download() {
	cd $MODEL_ZOO_SRC_DIR/tools/downloader
	./downloader.py --all -o $MODEL_DIR --cache_dir $CACHE_DIR
	cd -
}

function model_zoo_convert() {
	cd $MODEL_ZOO_SRC_DIR/tools/downloader
 	./converter.py --mo $DLDT_SRC_DIR/model-optimizer/mo.py --all --download_dir $MODEL_DIR
	cd -
}

function ovms_setup() {
 	mkdir -p $MODEL_DIR
	mkdir -p $CACHE_DIR
	cp ovms-config.json $MODEL_DIR
	cd $SRC_DIR
	git clone https://github.com/IntelAI/OpenVINO-model-server.git
	git clone https://github.com/opencv/open_model_zoo.git
	cd -
	docker pull $OVMS_IMAGE_NAME
}

function ovms_start() {
	docker run --rm -d  \
	--name ovms-1 \
	-v /opt/models/:/opt/ml:ro \
	-p 9001:9001 -p 8001:8001 \
	$OVMS_IMAGE_NAME \
	/ie-serving-py/start_server.sh ie_serving model --model_path /opt/ml/resnet_V1_50 --model_name $OVMS_MODEL_NAME --port 9001 --rest_port 8001
}

function ovms_start_with_config() {
	docker run --rm -d  \
	--name ovms-2 \
	-v /opt/models/:/opt/ml:ro \
	-p 9001:9001 -p 8001:8001 \
	$OVMS_IMAGE_NAME \
	/ie-serving-py/start_server.sh ie_serving config --config_path /opt/ml/ovms-config.json --port 9001 --rest_port 8001
}

function ovms_inference_resnet() {
	cd $OVMS_SRC_DIR/example_client
	python grpc_serving_client.py \
	--grpc_port 9001 \
	--images_numpy_path imgs.npy \
	--input_name input \
	--output_name resnet_v1_50/predictions/Reshape_1 \
	--transpose_input False \
	--labels_numpy lbs.npy
  	cd -
}

function ovms_model_info() {
	cd $OVMS_SRC_DIR/example_client
	python get_serving_meta.py --grpc_port 9001 --model_name $OVMS_MODEL_NAME --model_version 1
	cd -
}
