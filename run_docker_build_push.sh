echo "###### build tmp ############"
if test -d tmp; then rm -rf tmp; fi
mkdir tmp
cd tmp

echo "###### git clone ############"
git clone https://github.com/agreif/phx-hive-record.git
cd phx-hive-record
cp ../../Dockerfile .

echo "###### build docker image ############"
docker image build -t agreif/phx-hiverec .

echo "###### push docker image ############"
docker push agreif/phx-hiverec

echo "###### cleanup tmp ############"
cd ../..
rm -rf tmp

echo "###### remove local docker image ############"
docker image rm agreif/phx-hiverec
