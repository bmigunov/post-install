#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to download bladRF images.




BLADERF_X40_IMAGES_DIR="${IMG_DIR}/bladerf/x40"

BLADERF_FX3_IMAGE_LATEST_REMOTE=\
"https://www.nuand.com/fx3/bladeRF_fw_latest.img"
BLADERF_X40_FPGA_BITSTREAM_LATEST_REMOTE=\
"https://www.nuand.com/fpga/hostedx40-latest.rbf"
BLADERF_FX3_2_3_2_IMAGE_REMOTE="https://www.nuand.com/fx3/bladeRF_fw_v2.3.2.img"
BLADERF_X40_FPGA_BITSTREAM_0_11_1_REMOTE=\
"https://www.nuand.com/fpga/v0.11.1/hostedx40.rbf"


function bladerf_x40_images_download()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Downloading bladeRF x40 images..."

    wget --content-disposition -P "${BLADERF_X40_IMAGES_DIR}" \
         "${BLADERF_FX3_IMAGE_LATEST_REMOTE}"
    wget --content-disposition -P "${BLADERF_X40_IMAGES_DIR}" \
         "${BLADERF_X40_FPGA_BITSTREAM_LATEST_REMOTE}"
    wget --content-disposition -P "${BLADERF_X40_IMAGES_DIR}" \
         "${BLADERF_FX3_2_3_2_IMAGE_REMOTE}"
    wget --content-disposition -P "${BLADERF_X40_IMAGES_DIR}" \
         "${BLADERF_X40_FPGA_BITSTREAM_0_11_1_REMOTE}"
}
