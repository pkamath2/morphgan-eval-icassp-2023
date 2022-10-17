#!/bin/sh

echo '############################SEMANTIC#############################'

water_dir='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/training-data/stats/water/water'
wind_dir='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/fad_data_folder/water-wind/training-data/stats/wind/wind'


mix_fadaudiofiles=$PWD'/fad_data_folder/water-wind/mix/audio/middle_files'
mix_fadfilelist=$PWD'/fad_data_folder/water-wind/mix/fadfilelist/middle_files'
mix_stats=$PWD'/fad_data_folder/water-wind/mix/stats/middle_files'

rm -rf $mix_fadaudiofiles
rm -rf $mix_fadfilelist
rm -rf $mix_stats

mkdir -p $mix_fadaudiofiles
mkdir -p $mix_fadfilelist
mkdir -p $mix_stats

# Pick all 0.5 of mix morphs.
mix_audio='/Users/purnimakamath/appdir/Github/ieee-tx-on-mm/data/water-wind/mix/audio/morph'

for i in {0..10}
do
    echo $i
    echo cp $mix_audio/$i/morphmorph_0.5.wav $mix_fadaudiofiles/$i-morphmorph_0.5.wav
    cp $mix_audio/$i/morphmorph_0.5.wav $mix_fadaudiofiles/$i-morphmorph_0.5.wav
done

cd '/Users/purnimakamath/appdir/Github/frechet_audio_distance/'
ls --color=never $mix_fadaudiofiles/* > $mix_fadfilelist/filelist.cvs

python -m create_embeddings_main --input_files $mix_fadfilelist/filelist.cvs --stats $mix_stats/0_5stats

echo 'FAD Distance from water ==== '
python -m compute_fad --background_stats $water_dir --test_stats $mix_stats/*


echo 'FAD Distance from wind ==== '
python -m compute_fad --background_stats $mix_stats/0_5stats --test_stats $wind_dir

echo '#################################################################'

