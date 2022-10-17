#!/bin/sh
echo '############################ONEHOT#############################'

morph2_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/morph2/audio/morph'

# FAD Data Folders
morph2_fadaudiofiles=$PWD'/fad_data_folder/water-wind/morph2/audio/morph'
morph2_fadfilelist=$PWD'/fad_data_folder/water-wind/morph2/fadfilelist/morph'
morph2_stats=$PWD'/fad_data_folder/water-wind/morph2/stats/morph'

echo $PWD

rm -rf $morph2_fadaudiofiles
rm -rf $morph2_fadfilelist
rm -rf $morph2_stats

mkdir -p $morph2_fadaudiofiles
mkdir -p $morph2_fadfilelist
mkdir -p $morph2_stats

cd $morph2_audio
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

        mkdir -p $morph2_fadaudiofiles/$i
        echo cp "$file" $morph2_fadaudiofiles/$i/$full_file_name
        cp "$file" $morph2_fadaudiofiles/$i/$full_file_name
    done
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'

for i in {0..10}
do
    ls --color=never $morph2_fadaudiofiles/$i/* > $morph2_fadfilelist/$i.cvs
done


for i in {0..10}
do
    python -m create_embeddings_main --input_files $morph2_fadfilelist/$i.cvs --stats $morph2_stats/$i
done

echo '------------------Onehot - fad------------------------'
for i in {0..10}
do
    echo 'Finding distance between' 0 'and' $i
    python -m compute_fad --background_stats $morph2_stats/0 --test_stats $morph2_stats/$i
done
echo '---------------------------------------------------------------'

echo '#################################################################'


