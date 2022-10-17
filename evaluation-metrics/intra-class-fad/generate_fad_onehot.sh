#!/bin/sh
echo '############################SEMANTIC#############################'

onehot_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/onehot/audio/semantic/'

# FAD Data Folders
onehot_audio_semantic_water=$PWD'/fad_data_folder/water-wind/onehot/audio/semantic/water'
onehot_fadfilelist_semantic_water=$PWD'/fad_data_folder/water-wind/onehot/fadfilelist/semantic/water'
onehot_stats_semantic_water=$PWD'/fad_data_folder/water-wind/onehot/stats/semantic/water'


onehot_audio_semantic_wind=$PWD'/fad_data_folder/water-wind/onehot/audio/semantic/wind'
onehot_fadfilelist_semantic_wind=$PWD'/fad_data_folder/water-wind/onehot/fadfilelist/semantic/wind'
onehot_stats_semantic_wind=$PWD'/fad_data_folder/water-wind/onehot/stats/semantic/wind'


rm -rf $onehot_audio_semantic_water
rm -rf $onehot_fadfilelist_semantic_water
rm -rf $onehot_stats_semantic_water

rm -rf $onehot_audio_semantic_wind
rm -rf $onehot_fadfilelist_semantic_wind
rm -rf $onehot_stats_semantic_wind

mkdir -p $onehot_audio_semantic_water
mkdir -p $onehot_fadfilelist_semantic_water
mkdir -p $onehot_stats_semantic_water

mkdir -p $onehot_audio_semantic_wind
mkdir -p $onehot_fadfilelist_semantic_wind
mkdir -p $onehot_stats_semantic_wind

cd $onehot_audio

# For Water
d1=$onehot_audio'2022-08-24 22:31'
d2=$onehot_audio'2022-08-24 22:33'
d3=$onehot_audio'2022-08-24 22:34'
d4=$onehot_audio'2022-08-24 22:35'
d5=$onehot_audio'2022-08-24 22:36'


echo "$d1" "$d2" "$d3" "$d4" "$d5"
for i in {11..21}
do 
    find "$d1" "$d2" "$d3" "$d4" "$d5" -type f -name '*_'$i'.wav' -print0 | while IFS= read -r -d '' file; do
        i1=$((i-11))
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $onehot_audio_semantic_water/$i1
        echo cp "$file" $onehot_audio_semantic_water/$i1/$full_file_name
        cp "$file" $onehot_audio_semantic_water/$i1/$full_file_name
    done
done

# For Wind
d1=$onehot_audio'2022-08-24 22:26'
d2=$onehot_audio'2022-08-24 22:27'
d3=$onehot_audio'2022-08-24 22:28'
d4=$onehot_audio'2022-08-24 22:29'
d5=$onehot_audio'2022-08-24 22:30'

echo "$d3" "$d4"
for i in {0..10}
do 
    find "$d1" "$d2" "$d3" "$d4" "$d5" -type f -name '*_'$i'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $onehot_audio_semantic_wind/$i
        echo cp "$file" $onehot_audio_semantic_wind/$i/$full_file_name
        cp "$file" $onehot_audio_semantic_wind/$i/$full_file_name
    done
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

for i in {0..10}
do
    ls --color=never $onehot_audio_semantic_water/$i/* > $onehot_fadfilelist_semantic_water/$i.cvs
    ls --color=never $onehot_audio_semantic_wind/$i/* > $onehot_fadfilelist_semantic_wind/$i.cvs
done


for i in {0..10}
do
    python -m create_embeddings_main --input_files $onehot_fadfilelist_semantic_water/$i.cvs --stats $onehot_stats_semantic_water/$i
    python -m create_embeddings_main --input_files $onehot_fadfilelist_semantic_wind/$i.cvs --stats $onehot_stats_semantic_wind/$i
done


echo '------------------Semantic - water fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $onehot_stats_semantic_water/0 --test_stats $onehot_stats_semantic_water/$i
done
echo '---------------------------------------------------------------'

echo '------------------Semantic - wind fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $onehot_stats_semantic_wind/0 --test_stats $onehot_stats_semantic_wind/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'





