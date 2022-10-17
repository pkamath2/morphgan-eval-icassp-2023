#!/bin/sh
echo '############################MORPH#############################'

morphgan_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/morphgan/audio/morph'

# FAD Data Folders
morphgan_fadaudiofiles=$PWD'/fad_data_folder/water-wind/morphgan/audio/morph'
morphgan_fadfilelist=$PWD'/fad_data_folder/water-wind/morphgan/fadfilelist/morph'
morphgan_stats=$PWD'/fad_data_folder/water-wind/morphgan/stats/morph'

rm -rf $morphgan_fadaudiofiles
rm -rf $morphgan_fadfilelist
rm -rf $morphgan_stats

mkdir -p $morphgan_fadaudiofiles
mkdir -p $morphgan_fadfilelist
mkdir -p $morphgan_stats

cd $morphgan_audio
for i in {0..10}
do 
    find . -type f -name '*_'$i'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $morphgan_fadaudiofiles/$i
        echo cp "$file" $morphgan_fadaudiofiles/$i/$full_file_name
        cp "$file" $morphgan_fadaudiofiles/$i/$full_file_name
    done
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

for i in {0..10}
do
    ls --color=never $morphgan_fadaudiofiles/$i/* > $morphgan_fadfilelist/$i.cvs
done



for i in {0..10}
do
    python -m create_embeddings_main --input_files $morphgan_fadfilelist/$i.cvs --stats $morphgan_stats/$i
done

echo '------------------Morph - fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $morphgan_stats/0 --test_stats $morphgan_stats/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'







# echo '############################SEMANTIC#############################'
# morphgan_audio_semantic_water='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/morphgan/audio/semantic/water'
# morphgan_audio_semantic_wind='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/morphgan/audio/semantic/wind'

# morphgan_fadfilelist_semantic_water='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/morphgan/fadfilelist/semantic/water'
# morphgan_fadfilelist_semantic_wind='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/morphgan/fadfilelist/semantic/wind'

# morphgan_stats_semantic_water='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/morphgan/stats/semantic/water'
# morphgan_stats_semantic_wind='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/morphgan/stats/semantic/wind'


# cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

# for i in 0 1 2 3 4 5 6 7 8 9 10
# do
#     ls --color=never $morphgan_audio_semantic_water/$i/* > $morphgan_fadfilelist_semantic_water/$i.cvs
#     ls --color=never $morphgan_audio_semantic_wind/$i/* > $morphgan_fadfilelist_semantic_wind/$i.cvs
# done



# for i in 0 1 2 3 4 5 6 7 8 9 10
# do
#     python -m create_embeddings_main --input_files $morphgan_fadfilelist_semantic_water/$i.cvs --stats $morphgan_stats_semantic_water/$i
#     python -m create_embeddings_main --input_files $morphgan_fadfilelist_semantic_wind/$i.cvs --stats $morphgan_stats_semantic_wind/$i
# done



# echo '------------------Semantic - water fad------------------------'
# for i in 0 1 2 3 4 5 6 7 8 9 10
# do
#     echo 'Finding distance between' 0 'and' $i
#     python -m compute_fad --background_stats $morphgan_stats_semantic_water/0 --test_stats $morphgan_stats_semantic_water/$i
# done
# echo '---------------------------------------------------------------'

# echo '------------------Semantic - wind fad------------------------'
# for i in 0 1 2 3 4 5 6 7 8 9 10
# do
#     echo 'Finding distance between' 0 'and' $i
#     python -m compute_fad --background_stats $morphgan_stats_semantic_wind/0 --test_stats $morphgan_stats_semantic_wind/$i
# done
# echo '---------------------------------------------------------------'

# echo '#################################################################'




