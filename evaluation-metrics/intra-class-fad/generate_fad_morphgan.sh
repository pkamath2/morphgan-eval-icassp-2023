#!/bin/sh
echo '############################SEMANTIC#############################'

morphgan_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/morphgan/audio/semantic/'

# FAD Data Folders
morphgan_audio_semantic_water=$PWD'/fad_data_folder/water-wind/morphgan/audio/semantic/water'
morphgan_fadfilelist_semantic_water=$PWD'/fad_data_folder/water-wind/morphgan/fadfilelist/semantic/water'
morphgan_stats_semantic_water=$PWD'/fad_data_folder/water-wind/morphgan/stats/semantic/water'


morphgan_audio_semantic_wind=$PWD'/fad_data_folder/water-wind/morphgan/audio/semantic/wind'
morphgan_fadfilelist_semantic_wind=$PWD'/fad_data_folder/water-wind/morphgan/fadfilelist/semantic/wind'
morphgan_stats_semantic_wind=$PWD'/fad_data_folder/water-wind/morphgan/stats/semantic/wind'


rm -rf $morphgan_audio_semantic_water
rm -rf $morphgan_fadfilelist_semantic_water
rm -rf $morphgan_stats_semantic_water

rm -rf $morphgan_audio_semantic_wind
rm -rf $morphgan_fadfilelist_semantic_wind
rm -rf $morphgan_stats_semantic_wind

mkdir -p $morphgan_audio_semantic_water
mkdir -p $morphgan_fadfilelist_semantic_water
mkdir -p $morphgan_stats_semantic_water

mkdir -p $morphgan_audio_semantic_wind
mkdir -p $morphgan_fadfilelist_semantic_wind
mkdir -p $morphgan_stats_semantic_wind

cd $morphgan_audio

# For Water
d1=$morphgan_audio'2022-08-24 21:38'
d2=$morphgan_audio'2022-08-24 21:39'
d3=$morphgan_audio'2022-08-24 21:40'
d4=$morphgan_audio'2022-08-24 21:41'
d5=$morphgan_audio'2022-08-24 21:42'

echo "$d3" "$d4"
for i in {0..10}
do 
    find "$d1" "$d2" "$d3" "$d4" "$d5" -type f -name '*_'$i'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $morphgan_audio_semantic_water/$i
        echo cp "$file" $morphgan_audio_semantic_water/$i/$full_file_name
        cp "$file" $morphgan_audio_semantic_water/$i/$full_file_name
    done
done

# For Wind
d1=$morphgan_audio'2022-08-24 21:44'
d2=$morphgan_audio'2022-08-24 21:45'
d3=$morphgan_audio'2022-08-24 21:46'
d4=$morphgan_audio'2022-08-24 21:47'
d5=$morphgan_audio'2022-08-24 21:48'

echo "$d3" "$d4"
for i in {0..10}
do 
    find "$d1" "$d2" "$d3" "$d4" "$d5" -type f -name '*_'$i'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $morphgan_audio_semantic_wind/$i
        echo cp "$file" $morphgan_audio_semantic_wind/$i/$full_file_name
        cp "$file" $morphgan_audio_semantic_wind/$i/$full_file_name
    done
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

for i in {0..10}
do
    ls --color=never $morphgan_audio_semantic_water/$i/* > $morphgan_fadfilelist_semantic_water/$i.cvs
    ls --color=never $morphgan_audio_semantic_wind/$i/* > $morphgan_fadfilelist_semantic_wind/$i.cvs
done


for i in {0..10}
do
    python -m create_embeddings_main --input_files $morphgan_fadfilelist_semantic_water/$i.cvs --stats $morphgan_stats_semantic_water/$i
    python -m create_embeddings_main --input_files $morphgan_fadfilelist_semantic_wind/$i.cvs --stats $morphgan_stats_semantic_wind/$i
done


echo '------------------Semantic - water fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $morphgan_stats_semantic_water/0 --test_stats $morphgan_stats_semantic_water/$i
done
echo '---------------------------------------------------------------'

echo '------------------Semantic - wind fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $morphgan_stats_semantic_wind/0 --test_stats $morphgan_stats_semantic_wind/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'





