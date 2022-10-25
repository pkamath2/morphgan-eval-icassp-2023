#!/bin/sh

echo '############################ONEHOT#############################'

water_dir=$PWD'/fad_data_folder/water-wind/training-data/stats/water/stats'
wind_dir=$PWD'/fad_data_folder/water-wind/training-data/stats/wind/stats'

onehot_audio='../../data/water-wind/onehot/audio/middle_100x11files'

onehot_fadaudiofiles=$PWD'/fad_data_folder/water-wind/onehot/audio/middle_100x11files'
onehot_fadfilelist=$PWD'/fad_data_folder/water-wind/onehot/fadfilelist/middle_100x11files'
onehot_stats=$PWD'/fad_data_folder/water-wind/onehot/stats/middle_100x11files'

rm -rf $onehot_fadaudiofiles
rm -rf $onehot_fadfilelist
rm -rf $onehot_stats

mkdir -p $onehot_fadaudiofiles
mkdir -p $onehot_fadfilelist
mkdir -p $onehot_stats

cd $onehot_audio
find . -type f -name '*.wav' -print0 | while IFS= read -r -d '' file; do
    full_file_name=${file/ /_}
    full_file_name=${full_file_name/./}
    full_file_name=${full_file_name/:/_}
    full_file_name=${full_file_name//\//_}
 
    cp "$file" $onehot_fadaudiofiles/$full_file_name
done


cd $FAD_LOC
ls --color=never $onehot_fadaudiofiles/* > $onehot_fadfilelist/filelist.cvs

python -m create_embeddings_main --input_files $onehot_fadfilelist/filelist.cvs --stats $onehot_stats/0_5stats

echo 'FAD Distance 0.5 distribution from water ==== '
python -m compute_fad --background_stats $water_dir --test_stats $onehot_stats/*


echo 'FAD Distance 0.5 distribution from wind ==== '
python -m compute_fad --background_stats $onehot_stats/0_5stats --test_stats $wind_dir

echo '#################################################################'

