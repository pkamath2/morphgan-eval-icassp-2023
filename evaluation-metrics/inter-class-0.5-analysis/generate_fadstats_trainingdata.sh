#!/bin/sh

echo '############################SEMANTIC#############################'

frechet_dir='/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

all_training_audio='../../data/water-wind/training-data/audio'

water_fadaudiofiles=$PWD'/fad_data_folder/water-wind/training-data/audio/water'
water_fadfilelist=$PWD'/fad_data_folder/water-wind/training-data/fadfilelist/water'
water_stats=$PWD'/fad_data_folder/water-wind/training-data/stats/water'

wind_fadaudiofiles=$PWD'/fad_data_folder/water-wind/training-data/audio/wind'
wind_fadfilelist=$PWD'/fad_data_folder/water-wind/training-data/fadfilelist/wind'
wind_stats=$PWD'/fad_data_folder/water-wind/training-data/stats/wind'

rm -rf $water_fadaudiofiles
rm -rf $water_fadfilelist
rm -rf $water_stats
rm -rf $wind_fadaudiofiles
rm -rf $wind_fadfilelist
rm -rf $wind_stats

mkdir -p $water_fadaudiofiles
mkdir -p $water_fadfilelist
mkdir -p $water_stats
mkdir -p $wind_fadaudiofiles
mkdir -p $wind_fadfilelist
mkdir -p $wind_stats


cd $all_training_audio
find . -type f -name 'water*.wav' -print0 | while IFS= read -r -d '' file; do
    full_file_name=${file/ /_}
    full_file_name=${full_file_name/./}
    full_file_name=${full_file_name/:/_}
    full_file_name=${full_file_name//\//_}

    echo cp "$file" $water_fadaudiofiles/$full_file_name
    cp "$file" $water_fadaudiofiles/$full_file_name
done


find . -type f -name 'DSWind*.wav' -print0 | while IFS= read -r -d '' file; do
    full_file_name=${file/ /_}
    full_file_name=${full_file_name/./}
    full_file_name=${full_file_name/:/_}
    full_file_name=${full_file_name//\//_}

    echo cp "$file" $wind_fadaudiofiles/$full_file_name
    cp "$file" $wind_fadaudiofiles/$full_file_name
done

cd $frechet_dir
ls --color=never $water_fadaudiofiles/* > $water_fadfilelist/filelist.cvs
ls --color=never $wind_fadaudiofiles/* > $wind_fadfilelist/filelist.cvs

python -m create_embeddings_main --input_files $water_fadfilelist/filelist.cvs --stats $water_stats/stats
python -m create_embeddings_main --input_files $wind_fadfilelist/filelist.cvs --stats $wind_stats/stats







