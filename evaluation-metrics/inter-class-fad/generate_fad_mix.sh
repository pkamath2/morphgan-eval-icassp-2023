#!/bin/sh
echo '############################ONEHOT#############################'

mix_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/mix2/audio/morph'

# FAD Data Folders
mix_fadaudiofiles=$PWD'/fad_data_folder/water-wind/mix/audio/morph'
mix_fadfilelist=$PWD'/fad_data_folder/water-wind/mix/fadfilelist/morph'
mix_stats=$PWD'/fad_data_folder/water-wind/mix/stats/morph'

echo $PWD

rm -rf $mix_fadaudiofiles
rm -rf $mix_fadfilelist
rm -rf $mix_stats

mkdir -p $mix_fadaudiofiles
mkdir -p $mix_fadfilelist
mkdir -p $mix_stats

cd $mix_audio
for i in {0..10}
do 
    A=$(echo $i/10 | bc -l)
    B=$(echo $A |  awk '{printf("%.1f\n",$1 + 0.0)}')
    find . -type f -name '*_'$B'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $mix_fadaudiofiles/$i
        echo cp "$file" $mix_fadaudiofiles/$i/$full_file_name
        cp "$file" $mix_fadaudiofiles/$i/$full_file_name
    done
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

for i in {0..10}
do
    ls --color=never $mix_fadaudiofiles/$i/* > $mix_fadfilelist/$i.cvs
done


for i in {0..10}
do
    python -m create_embeddings_main --input_files $mix_fadfilelist/$i.cvs --stats $mix_stats/$i
done

echo '------------------Onehot - fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $mix_stats/0 --test_stats $mix_stats/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'


