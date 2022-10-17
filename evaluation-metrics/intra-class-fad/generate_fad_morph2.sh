#!/bin/sh
echo '############################SEMANTIC#############################'

morph2_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/morph2/audio/semantic/'

# FAD Data Folders
morph2_audio_semantic_water=$PWD'/fad_data_folder/water-wind/morph2/audio/semantic/water'
morph2_fadfilelist_semantic_water=$PWD'/fad_data_folder/water-wind/morph2/fadfilelist/semantic/water'
morph2_stats_semantic_water=$PWD'/fad_data_folder/water-wind/morph2/stats/semantic/water'


morph2_audio_semantic_wind=$PWD'/fad_data_folder/water-wind/morph2/audio/semantic/wind'
morph2_fadfilelist_semantic_wind=$PWD'/fad_data_folder/water-wind/morph2/fadfilelist/semantic/wind'
morph2_stats_semantic_wind=$PWD'/fad_data_folder/water-wind/morph2/stats/semantic/wind'


rm -rf $morph2_audio_semantic_water
rm -rf $morph2_fadfilelist_semantic_water
rm -rf $morph2_stats_semantic_water

rm -rf $morph2_audio_semantic_wind
rm -rf $morph2_fadfilelist_semantic_wind
rm -rf $morph2_stats_semantic_wind

mkdir -p $morph2_audio_semantic_water
mkdir -p $morph2_fadfilelist_semantic_water
mkdir -p $morph2_stats_semantic_water

mkdir -p $morph2_audio_semantic_wind
mkdir -p $morph2_fadfilelist_semantic_wind
mkdir -p $morph2_stats_semantic_wind

cd $morph2_audio

# For Water
d1=$morph2_audio'0'
d2=$morph2_audio'1'
d3=$morph2_audio'2'
d4=$morph2_audio'3'
d5=$morph2_audio'4'
d6=$morph2_audio'5'

for i in {0..10}
do 
    find "$d1" "$d2" "$d3" "$d4" "$d5" "$d6" -type f -name '*waterfill--fill-'$i'--v*.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $morph2_audio_semantic_water/$i
        echo cp "$file" $morph2_audio_semantic_water/$i/$full_file_name
        cp "$file" $morph2_audio_semantic_water/$i/$full_file_name
    done
done

# For Wind
d1=$morph2_audio'6'
d2=$morph2_audio'7'
d3=$morph2_audio'8'
d4=$morph2_audio'9'
d5=$morph2_audio'10'
d6=$morph2_audio'11'

for i in {0..10}
do 
    A=$(echo $i/10 | bc -l)
    B=$(echo $A |  awk '{printf("%.2f\n",$1 + 0.0)}')
    find "$d1" "$d2" "$d3" "$d4" "$d5" -type f -name '*-0'$B'*.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        # full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $morph2_audio_semantic_wind/$i
        echo cp "$file" $morph2_audio_semantic_wind/$i/$full_file_name
        cp "$file" $morph2_audio_semantic_wind/$i/$full_file_name
    done
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

for i in {0..10}
do
    ls --color=never $morph2_audio_semantic_water/$i/* > $morph2_fadfilelist_semantic_water/$i.cvs
    ls --color=never $morph2_audio_semantic_wind/$i/* > $morph2_fadfilelist_semantic_wind/$i.cvs
done


for i in {0..10}
do
    python -m create_embeddings_main --input_files $morph2_fadfilelist_semantic_water/$i.cvs --stats $morph2_stats_semantic_water/$i
    python -m create_embeddings_main --input_files $morph2_fadfilelist_semantic_wind/$i.cvs --stats $morph2_stats_semantic_wind/$i
done


echo '------------------Semantic - water fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $morph2_stats_semantic_water/0 --test_stats $morph2_stats_semantic_water/$i
done
echo '---------------------------------------------------------------'

echo '------------------Semantic - wind fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $morph2_stats_semantic_wind/0 --test_stats $morph2_stats_semantic_wind/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'





