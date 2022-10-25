#!/bin/sh

echo '############################MORPHGAN#############################'

water_dir=$PWD'/fad_data_folder/water-wind/training-data/stats/water/stats'
wind_dir=$PWD'/fad_data_folder/water-wind/training-data/stats/wind/stats'

morphgan_audio='../../data/water-wind/morphgan/audio/middle_100x11files'


# FAD Data Folders
morphgan_fadaudiofiles=$PWD'/fad_data_folder/water-wind/morphgan/audio/middle_100x11files'
morphgan_fadfilelist=$PWD'/fad_data_folder/water-wind/morphgan/fadfilelist/middle_100x11files'
morphgan_stats=$PWD'/fad_data_folder/water-wind/morphgan/stats/middle_100x11files'

rm -rf $morphgan_fadaudiofiles
rm -rf $morphgan_fadfilelist
rm -rf $morphgan_stats

mkdir -p $morphgan_fadaudiofiles
mkdir -p $morphgan_fadfilelist
mkdir -p $morphgan_stats

cd $morphgan_audio
find . -type f -name '*.wav' -print0 | while IFS= read -r -d '' file; do
    full_file_name=${file/ /_}
    full_file_name=${full_file_name/./}
    full_file_name=${full_file_name/:/_}
    full_file_name=${full_file_name//\//_}

    cp "$file" $morphgan_fadaudiofiles/$full_file_name
done


cd $FAD_LOC
ls --color=never $morphgan_fadaudiofiles/* > $morphgan_fadfilelist/filelist.cvs

python -m create_embeddings_main --input_files $morphgan_fadfilelist/filelist.cvs --stats $morphgan_stats/0_5stats

echo 'FAD Distance 0.5 distribution from water ==== '
python -m compute_fad --background_stats $water_dir --test_stats $morphgan_stats/*


echo 'FAD Distance 0.5 distribution from wind ==== '
python -m compute_fad --background_stats $morphgan_stats/0_5stats --test_stats $wind_dir

echo '#################################################################'

