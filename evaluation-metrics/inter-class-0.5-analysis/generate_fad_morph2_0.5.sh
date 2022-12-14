#!/bin/sh

echo '############################MORPH2#############################'

water_dir=$PWD'/fad_data_folder/water-wind/training-data/stats/water/stats'
wind_dir=$PWD'/fad_data_folder/water-wind/training-data/stats/wind/stats'

morph2_fadaudiofiles=$PWD'/fad_data_folder/water-wind/morph2/audio/middle_files'
morph2_fadfilelist=$PWD'/fad_data_folder/water-wind/morph2/fadfilelist/middle_files'
morph2_stats=$PWD'/fad_data_folder/water-wind/morph2/stats/middle_files'

rm -rf $morph2_fadaudiofiles
rm -rf $morph2_fadfilelist
rm -rf $morph2_stats

mkdir -p $morph2_fadaudiofiles
mkdir -p $morph2_fadfilelist
mkdir -p $morph2_stats

# Pick all 0.5 of MORPH2 morphs.
morph2_audio='../../data/water-wind/morph2/audio/morph'

for i in {0..10}
do
    cp $morph2_audio/$i/classmorph_0.5.wav $morph2_fadaudiofiles/$i-classmorph_0.5.wav
done

cd $FAD_LOC
ls --color=never $morph2_fadaudiofiles/* > $morph2_fadfilelist/filelist.cvs

python -m create_embeddings_main --input_files $morph2_fadfilelist/filelist.cvs --stats $morph2_stats/0_5stats

echo 'FAD Distance of 0.5 distribution from water ==== '
python -m compute_fad --background_stats $water_dir --test_stats $morph2_stats/*


echo 'FAD Distance 0.5 distribution from wind ==== '
python -m compute_fad --background_stats $morph2_stats/0_5stats --test_stats $wind_dir

echo '#################################################################'
