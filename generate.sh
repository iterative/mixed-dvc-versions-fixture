rm -rf .git
rm -rf .dvc
rm -rf dvclive
rm -rf .venv
rm .gitignore
rm .dvcignore
rm dvc.lock
rm dvc.yaml
rm params.yaml

git init
python3 -m venv .venv
echo .venv >> .gitignore
source .venv/bin/activate
git add .gitignore

pip install dvclive 'dvc[s3]<3'
dvc init
export AWS_PROFILE=iterative-sandbox
dvc remote add -d --local storage s3://dvc-public/remote/mixed-dvc-versions
dvc remote add -d storage https://remote.dvc.org/mixed-dvc-versions
git commit -m "init"

dvc stage add -n train -m dvclive/metrics.json --plots dvclive/plots "python train.py \${epochs}"
echo 'epochs: 3' > params.yaml
dvc repro
git add .
git commit -m "DVC 2"
git push
dvc push

pip install 'dvc[s3]>=3'
echo 'epochs: 4' > params.yaml
dvc repro
git add .
git commit -m "DVC 3"
git push
dvc push