#!/bin/sh
echo '############################SEMANTIC#############################'

mix_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/mix2/audio/semantic/'

# FAD Data Folders
mix_audio_semantic_water=$PWD'/fad_data_folder/water-wind/mix/audio/semantic/water'
mix_fadfilelist_semantic_water=$PWD'/fad_data_folder/water-wind/mix/fadfilelist/semantic/water'
mix_stats_semantic_water=$PWD'/fad_data_folder/water-wind/mix/stats/semantic/water'


mix_audio_semantic_wind=$PWD'/fad_data_folder/water-wind/mix/audio/semantic/wind'
mix_fadfilelist_semantic_wind=$PWD'/fad_data_folder/water-wind/mix/fadfilelist/semantic/wind'
mix_stats_semantic_wind=$PWD'/fad_data_folder/water-wind/mix/stats/semantic/wind'


rm -rf $mix_audio_semantic_water
rm -rf $mix_fadfilelist_semantic_water
rm -rf $mix_stats_semantic_water

rm -rf $mix_audio_semantic_wind
rm -rf $mix_fadfilelist_semantic_wind
rm -rf $mix_stats_semantic_wind

mkdir -p $mix_audio_semantic_water
mkdir -p $mix_fadfilelist_semantic_water
mkdir -p $mix_stats_semantic_water

mkdir -p $mix_audio_semantic_wind
mkdir -p $mix_fadfilelist_semantic_wind
mkdir -p $mix_stats_semantic_wind

cd $mix_audio

# For Water
d1=$mix_audio'0'
d2=$mix_audio'1'
d3=$mix_audio'2'
d4=$mix_audio'3'
d5=$mix_audio'4'
d6=$mix_audio'5'

for i in {0..10}
do 
    A=$(echo $i/10 | bc -l)
    B=$(echo $A |  awk '{printf("%.1f\n",$1 + 0.0)}')
    find "$d1" "$d2" "$d3" "$d4" "$d5" "$d6" -type f -name '*_'$B'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $mix_audio_semantic_water/$i
        echo cp "$file" $mix_audio_semantic_water/$i/$full_file_name
        cp "$file" $mix_audio_semantic_water/$i/$full_file_name
    done
done

# For Wind
d1=$mix_audio'6'
d2=$mix_audio'7'
d3=$mix_audio'8'
d4=$mix_audio'9'
d5=$mix_audio'10'
d6=$mix_audio'11'

for i in {0..10}
do 
    A=$(echo $i/10 | bc -l)
    B=$(echo $A |  awk '{printf("%.1f\n",$1 + 0.0)}')
    find "$d1" "$d2" "$d3" "$d4" "$d5" -type f -name '*_'$B'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $mix_audio_semantic_wind/$i
        echo cp "$file" $mix_audio_semantic_wind/$i/$full_file_name
        cp "$file" $mix_audio_semantic_wind/$i/$full_file_name
    done
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

for i in {0..10}
do
    ls --color=never $mix_audio_semantic_water/$i/* > $mix_fadfilelist_semantic_water/$i.cvs
    ls --color=never $mix_audio_semantic_wind/$i/* > $mix_fadfilelist_semantic_wind/$i.cvs
done


for i in {0..10}
do
    python -m create_embeddings_main --input_files $mix_fadfilelist_semantic_water/$i.cvs --stats $mix_stats_semantic_water/$i
    python -m create_embeddings_main --input_files $mix_fadfilelist_semantic_wind/$i.cvs --stats $mix_stats_semantic_wind/$i
done


echo '------------------Semantic - water fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $mix_stats_semantic_water/0 --test_stats $mix_stats_semantic_water/$i
done
echo '---------------------------------------------------------------'

echo '------------------Semantic - wind fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $mix_stats_semantic_wind/0 --test_stats $mix_stats_semantic_wind/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'





