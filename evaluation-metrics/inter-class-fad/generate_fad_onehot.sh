#!/bin/sh
echo '############################ONEHOT#############################'

onehot_audio='../../data/water-wind/onehot/audio/morph'

# FAD Data Folders
onehot_fadaudiofiles=$PWD'/fad_data_folder/water-wind/onehot/audio/morph'
onehot_fadfilelist=$PWD'/fad_data_folder/water-wind/onehot/fadfilelist/morph'
onehot_stats=$PWD'/fad_data_folder/water-wind/onehot/stats/morph'

echo $PWD

rm -rf $onehot_fadaudiofiles
rm -rf $onehot_fadfilelist
rm -rf $onehot_stats

mkdir -p $onehot_fadaudiofiles
mkdir -p $onehot_fadfilelist
mkdir -p $onehot_stats

cd $onehot_audio
for i in {0..10}
do 
    find . -type f -name '*_'$i'.wav' -print0 | while IFS= read -r -d '' file; do
        full_file_name=${file/ /_}
        full_file_name=${full_file_name/./}
        full_file_name=${full_file_name/:/_}
        full_file_name=${full_file_name//\//_}

        echo $full_file_name $file

        mkdir -p $onehot_fadaudiofiles/$i
        echo cp "$file" $onehot_fadaudiofiles/$i/$full_file_name
        cp "$file" $onehot_fadaudiofiles/$i/$full_file_name
    done
done

cd $FAD_LOC

for i in {0..10}
do
    ls --color=never $onehot_fadaudiofiles/$i/* > $onehot_fadfilelist/$i.cvs
done



for i in {0..10}
do
    python -m create_embeddings_main --input_files $onehot_fadfilelist/$i.cvs --stats $onehot_stats/$i
done

echo '------------------Onehot - fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $onehot_stats/0 --test_stats $onehot_stats/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'


