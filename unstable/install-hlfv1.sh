ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.12.3
docker tag hyperledger/composer-playground:0.12.3 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� W��Y �=�r��v����)')U*7���[c��M���\EK��E�%����$DMc!E�x+�p�����C���������H�Dόy$�q��v�n�>T��Bf@���P���~�Ď��m����@ ����$����H�#1,FcQIGH����G@����c����m®f��[��W
]dZ6��3��Y��j
��9 �'�m�~3l���`�6�����Z6HY��A���2C��c,�P;ش-�$ �lK���g�]��F�)uP8<�d�R�l>�~� p���+�T-~��,����UhC�2�a���!SVۚ������:�n^��J��Ȧ�գJ&�������0��t�!���0����E}?��`6m������ԡ�뚎n6�M�k��,��,��:�6��;b6�e�AW
�(ؤ��ZW\��B�c�Wll2�P���ѡ���d�T��ԭ��jm���aAX��M�D �����i9�N��0;�v(�Q���舎`;.D���Na0�)�Bqي�>��aтZm��O�:fC,T�*�%��x�o�v��_�AL�N�?�LD��9�����#�`����裃,���?�̔�0s���ݧ����oJ1�ɼs;�2&b��pt��`Dq���a��L�����=C�.ldP��I3����>�A^1�j7��n��{o�:y�xt��G����R��1&<�{�������o#�F��ՠռkl����_�$��d# ����G����_<�.TӌPZM�� �?}��S5��I��*)Wv?T�ʩ�[����<��{���S胎!�0�|i
�W3��>]��*�����U�Z��l�!���`�-l�K��/2��O�������E@w��.�:3�]#�R!(�n��y�;�Vf:�6�sN��$�.�q����ӲA�1�v�k�cj]hӮ٦�X���s��f�?��u���r�w��Œ'M�Fw���g�6ƺ��9o'�C�nbs��)��p��k
2,ֶL����w EO��6Tm��������Xi)M����:���{o�;� [`Ec�W~�ٷF�Ps4]@Sij]��7����Ł���!Z@�{4Z���� ����p0"��@�Rs�����>"�=IL=�!5���i��&��������i�v�.��O"O'��$�Bd��W���P/�����	m��t@C&j�."���ahFc�R���J��;�7�+�;w�>W��79��Ro�P$�w;����W��ATR��{�=J�f�����#�y��^���2W�H��d�p�uin�e:�a�7i�lF���Ŭ?�x|��[2@�!�Ϙ����p�i���y[�q�ޢk��cv	d�=��ve~l� ��yn`���e�)���&�QA �Mq6�>�����Х蓘�Ohw������{�\��lV��]��c�n��rq��Jx�?����������y6�G�s�Gk�9cN�=`��xo��{s����M�#�7�f�e����l�^�N�oTi�O�~=��&�W �L[�^��Z�ݩyu���C��#*�����_*̰���������bѸ�������ϗ3�������#R|Z�����j���ңs�;s�����iW��c&�y�z�9�\'�1MJ�h��`�ϥ��OP'\u7_�PI��՝��nB^5����������ӫ1��3�%�,.������|��q�\�_\Fn���N  ��a!�%q�-�Mpc���\�v�P"��O�P�[�gO'��ҝ���V�r����/d���{=�6��b<�Y,�ڼ6���;b��M���Oo�@����,*�t�;��-x:��?��&��K˹]�E�C`8�2y����+��֥s�d��:��M+a2�~>�8�,�O�A�'���r���������;9/��.�����$����j`��}�0s�M�>7���?,
��_<���_	ܿ�sO>��{bt�@3Ȃ�::&�k`h�	a���e_k�;�������2�����}��X��l�s'.����7���_	�t�����G����?����J`��o��±A��ed��|	:�f���v���<����#���ba'��c"N.�vw~v���^|J��c"B��tl���Ѿ�`�'V߲Q� #�{֐�D�Y��ҿޫ��X�O��˱�gҙ!�.�����Աu$e#����<~�̿JG\!�	���ŞB]�	�0��.R����ke�0�:x�3��{g�wJ����i0p(:�����-�M��]���xd��'���Z�?<�]��
�H��
���ㅈذ��R��GgD�з�^r�p Z{<��xz�q�����2|�
[AF�6�;��j;JS�MTY��7���,��h$6%�R4�����/��[�#�b�Z�i���	�?1���zh��G��*�T���Rhi�olZ�#��:�w%pW�����mvCd�3}z?��N`� Mwƞ2:�F0���k�HwA�3�*�tf( �@�[�v�I�~�0��6���B��?�d������	���MݥO�23/ɕ{��RE��l[��Y�� �e
�rvL�嘨�_�Ʉ>K�oxY#f�՘J43]�D��2feØ�0� cr�S�c�^�2��ic�'M�� e,��p��(�YW��<��"�G��Yɼ[�Ռ��/(<�77��C�	m���_�K����*���?Rb�z
��ڠ�����O��D��u��J�������o����������5�S�營P�&(���ت+�"F�^�G��D"V�%���("�H,��%�F�DB�ŷ�Rm+������|�Mސ7���;���5�Gd�����+j�6}���Rذ�ikN{�7���Z�Q������_��$��_}�Ո�s�g	���o~����#�����͉I6������o��q�2��c8^��������Wޅ��?�po����XX����'���c�&m,������Ą�Z����=�x�P���TR��4��G�Mҗ<������<yz=��d)�}�[Z��������Q�@XP<V�J|+,lշ��Dj[J""��	��BA	G�[q���q0��I�O�WQ�uj�p��\�R�r5�ͧ�j���3
�|*w�J�J�!��I��/�E��8.�諡d����5�i�^�q���g��s!Cp{�ef�P�[9Y<�$����q�"s)����1!UM���ZNo�¯x��Ȟ�G�3��>&ϴd��Ω�_�J[�������L.�?��8go��ڛ�uV���$�b7-C�P�H��;c�=���T����+��B5/T��	-;ge°�qr��JV/U:M�J�L����e�Z GG�J�JRւ'g]��V3'�d��E���8��N>s�?=���7���e�^H
C��NJ'e�De2F��Q.k+�}�]�֪�32��B.����"	��ɥR��^fW�r2�l�]$Kb�uQ���~7^|��G�X���I��:�k�N��z��~
��,T+�-���g�^z�X�筂zX��E2�\��w^�&�r��魚�e��^���n#-�\�I�����e�����|��*���|�m�A'��'�������?v�D����R�XA�^Gw	�;�##+����\���T��+���L�c�z�"[�2=I���ًx:E��w���P#ߨD�b�]|�Wqg:0��q���xs\�=���OE�Z<*�;���bz���� 
�~��Fc_3Z�c��?��S������(Ƅ�#��@�����71��-{�+�O��w�����s�}+Z�%�������(F��+�1?鰜?&��eNY�c�����,/��ɜЃԇ*������'��Jh�Z�1wv �*�Nt��g�H�,��i�+%�e���JG�r�pԺ��T���q����j<�"ǭ�~��G�:��J9��j�G;�	IP�C�#���ޭ
����&.�s��>��=��e���u�]��U�g��N�s}�~�_�e���?W���(��O���l����z�)����咒.5����L6}��ׅ����D��с���cdϲ�V)N��s�-'����#����.m�n�aOܷ�ޅ����j����θ���瞵�|���;6��%u����J���]���F��WO@
w�&���'��	Y�A��Y��_�A�	��<L�	�io�Yn]C�6�%x1p@��nҁٰx iT��EL�:�ꂆv��-Іl��'^�0��.��g���CO�~�Sz^@; ��oF- ��m��`,����w۔"_� ��b!@_;�Y5��A��FG6c	��7�+���Ŗ��,��;�����ޘ�idۃ��'ſ�A���q�tx�C���?2h�-����,ӑ�I���W��w�l�Wc,D#i8+�c��蹆�1_(�X4$�G/0���r)�"PEd���^���R��a��� �4a�6HI�lSC��!6`T֧m[�A�{S����=��8 ���GG#ۋMPm2�_ؠ(�K`A����E��I�9Æ���ʀ�&�5Pn5�Mh�� &>�������$к�"_�?�I����h���'fl!�WW���� ��r�`�/$�妭�k�}2�]�;d�u�Yg�}����JD��6_Y�h]�����c�vz���2��.��<)���e|�	����ql�8\\�o*@ [JY1X#83�T���ˇS.C	|8�B\;�݋�T "�66��JإH�C�-F�"���G�1�e x]Jt�[��Bn�����[K��'���C�;�1~��\�^���h�%�Y�͗��n���e�6Tt�W��M��7L_����U��l�Ql�>���5�N�`��u#�v�*C:14�t۱:!D�(�c)"�b86�԰���y*��dM[������;:��kh".�htB�
�*�ݞ��c�W��k�G:��ꄎ�m��\�Ӿ�~�Hd�v;d�|�1O�i0 ��\|0q:�Xn���Au�C�mPQ�3| ��*����X����wj��l�?=���b�� ���m,�����0���I�:�w%��߂�g�Zb��rwO�\�MO��~P0C�f�Q_��H�$�)���I���<Y\9��8q7v�$T,���H�b��`�،@�� ,b�����q�U�5�Vߺ�>����w�?����џ���7����ߞ�5�����b�������/~����5��8�9�|G�o����Go�b������	U���0��dE¤pH�P�Z�P8ҔCxL�H
k��n�R!�2Nd[��9d�B��������������?��������ln� ��ǁ�Ð�b�����>��
E�����w�����{��� ���G����P���a�ˇ�~����o��[��v���+ ��2p�b6��u��򱡥c)��{e�a�S��9��{�|���=f	�U�m�U.�
�Ӳw��nT������b����0�yvIB�>zR�5$���~V�!BJ�Ǘt�F��EZ��BQ09{h<g��zu>nb��@�
ź���g�5�p�8Lw���EdgB�o&L�ᔛ3��[�̠�Wq��,O�D������<,�ͳ�z�ܝ��H�@�T�a���~�/O�f gλhչi��y}���K#����X�5Š�t�ZL��Hw�Hdg%�ܜ)�b��2�])��ɂn�<]H�m�}'9�(D�����za��dM�Y�3�M@ϖ�B�
a��:I���#:�I7�s�|�4Ҥ���Y���������ÛE�hUY��N|1�Z�g0u��2�E5ry�f���3�u��֗��i'�'kZ�LRҬZ*E:9�ҳq�ss�?9�Ǌ�!����%tu6��.���Jn���+��+��+��+��+��+��+��+��+��+�����1�w�7K)��~�T��d��α�v�YMċ1��ĩl��i��p��v�{Q;+
�U99_"@��E� ࡐ��Z� @��N�D͔� t7o`������Z���S�!VLF��М!2�<2�H�*�[��6K�X5E��L�PK��9��U�
'�R�Q459��Mpb46GR�,PW���?7Q?�ƈn��X��X��Ζ��k�TN�{KoEd�2C�¹y���ЩY8�Ñ)��Q
>����L�5�z�Sd�HGq���Z&B�X-��
�̝VT��(�&�<"cmVj����`��%\�]�B��_�����G����8z������c�y����p�]��wC�3佸}.6���0?���"�I�����ܾ?� u���ԩ���w pd�����׼\T,�����G��}��o ��\��џ:��?��a������_\)�2KK���J��Ft�u��3�E��k��nm�|I|�:?��%W�ǉM�o�	[���I������,X�ӕ\�m�f��Bl�U0��#�LcS���J��~&JU�E��r�Ϭ��0&�cB�QJ�%�HE�T�J�㼒���Wg�rl�gs�o�S�� �7��n��ユ���IӘ7´mW��A"�Q�q�2£&R�-e�P�C�,�]��Y�i2�:~�Y:���4�
qH2�)�L����r�24�Q�r;y�G"���[h�`�Ҩ[��zI�"k���M�,��*�֔E?_K6q�[*8&*�H�_�YD#�hA��f������icL/�m�2C�֔��l���tm�VB'>��_f<��+�&�g(�i��˃�0�d�h&�w���rK��_��/���̦��X��@fٮ����p�������Ȳ�EVY�x��=3+=.�;r[~w��6~��;ݳ�D�Yզ���T8��B.ӡeO6t�������3y����i��`�aI�f��~U-��Ju��a�)f�a�nm��|�F�x��6�4U��g���P�
-Цm(s��h�<�����&?�;��\ G�B>�w������Ǒj�����	�B0�s�҉'��.Y|���i��+�FEI��}�,��t)2K#L�͛�!p�y�(Z�a�p4�J����s��.L�+źx?��!��(�^���&��+y"+E�X)!;�Ú�
x���])$lY%f�ݯ"�I�Q$�k?j�m�`��	�	r�#W� +;�Re"Y�1W��9�*Ŀ�Z����P�\i����:����'O�ꀋM�$�sq�nW��Q(��[�c\��X��EI���YJ+�G�n2�-�ә�D��	�(�U(��Qv(�H9S�C�L�|�4%/�C��I��T�<�)ļ�N��R���
Ct3j)���p�,4�S��+U�!ҵZl��g$����J���Q˨Ę�y�J��)0��(,���am!6�j��c�w3yvihe��j�[���g��x�o�y��n�~���d�v!��%�c�ݘ��W������/#?Ns��>���X	<���������1�3�d��%u���}�<x��9����A/Ϸ�w`�v�x7�&�����)�u|èH�*�>$����$��J����ȃ�������Yu��G���	��p�dHN���9���;�?+}���#�šey�躢��#�C����=z]���Y9B^��;���[|�x"c~=�/LW|�èЖ��p?|��Gz9�_��>z�	�:�G���Y��V���5����N� ��T�|9ص2����#�A�ɰ*I���4P�.v�����Q o��f_����'0���ϑ�I�3��U?��vW@��wN��:oXU��e��ѥ�e�p?]��xo}�Y׋llݮ��V �W��bNvt�dG�^6��S�{{��:����dC�N���Ѹ�G�ڀ"��=,iA�1
@>ڈA�)��Yt?Q`��� �3����PїA������a���&����� �1^0�s�$䍠�M598T,��]N}*�~yj�Wsj�2 ��,>_�� �jd�0�!�l�x�xK|t���]�C�8s"�������W��Zom���A��h��p�NFC�Wf�:竍g���`�`}?iE�<�Uae�Wa�ɪ�
E��c,]gh�cm�kd�v���N�k��Б��1�>k�c�,�ۀ��ɸ�Ћ�'�� �a~�[�X�N�őU��	WDV���_�����	?3 WL�Xٜ�M�����u�y�����h�lH؏���V��u���ůK~������&x�d2�u��c�������Б��� �N�
��`iA�덺\��Yp���7��O�x0�27�j��'p��yC��G I	|�<���E>�]]�R�88sx�n�%��}<�%��h+[�0(i�+YE��֕��r��m)y��S���p���t;��
�Rɽ}Q�.�z&��}�*i��s�����/���;u��[ Y춽-���/�x�݅�A���4 (O(t�Ǡ����푋�*T
6AYX��,�$H�뵃�`g�����z`u���A΀$ xU9�cM�H�`��cf�\L���+��5����
7i��悐1ktӚ穥�A��°&ٞ+��v�M�x��6��/��W&��YÒW]\u��J�9MX-;ǢA���.�/p�e�{c���_�v[���6,�i�q�U_�V�N��n��4���*Y�]l5�`WB�D�ԙ�S�''���ɨԃ�aM�!]�<���8� ��YW����lN�N :��O`����X�Mܶ6�4ND�b p�I�+I῜�FnG����- 	l�);JC:@��[�������c3�M���X��_�p�P>=�U ��~ԁ��x׎�e-���\�}�����o;�͕m\q�����?�P;���#���	�	� P[�U�#�-+a0��kD�}��=����Y�>�1����BwV��䎂%�X��,mU����G���|���v���?g���+:��7kG"Yj�H�IHR���E"CJ�lST��Rڸi�D4C��1Bn���%��QE"(�L�ۂ�=���� f>sb�XVi7���d�?��|b=y
�
c�\{;ě0�ξ��Y�xLjR��l6�p�Ȓ�J��I1I�(*S"X��*!�)�RȚ�hL	G\�$Ś���������'�'p6f��6P|����޹%�'���Nx�3���.*�2���,�#��+���l�+�\Ѣ�$��t�,�Kf�
�y&+�i��l|I�4��R��+�����_81�c����+��f/����k�*Ng�R�g���Ǯ�"]mua��ݳ.x�� ��ڑ���t��3�j�>i���N�����j�i];l�}�¶I{�L��Z�v�c;7L���l��9CV�Hv��%�)��V���=�+r�ȓ|6y��������g�9v���	�c�����˲���M���EQp��It2:��S�O��$h�̢�KO��y]n�`6���f��\��*�ʕ�x.���gYN�抧�5�g.��/��7��:���v&�]{�S�<:�1�j86i�-����?YZ���=����,sI�x�O��3&�/w�܈�d,~���m��(x�ę=xg�Y[�t���	��A�.bj��N�i��|��f��Ķ��7����B?&��
|k���2���Շ��Gm�;�$�0r�c��v�].nv��ݱ��VD�C��Y������
���^�l�x7�o׋6y7��&��!��>���Gw�q��Y�;qX�}���[2�6�""�a���^	��$���;���Gz��ohzK�M��C�C����B�S����Kz�?�c�򟌄�i_������}O�W6�K�_��'7�������t�@s�@s�@�B=��7K�(���#�����Kڗ���1���,��#Q�dG��f;D�Yj�"Q��PQ,��Bd$Ԍ��J�<LH�3�eQ�W;�
���o���_{I>�o3L�����:4��H+���9r\��hJh8�A��P��+�ye�In�O%�
�9�.rM}is����C
�1��-.��hY����Tč����[��餔��&�Jq��R�J�)�����1��������/?�
��p����r��<��i����:���#�
��v����i_��l�}�+��� ��_�o�����A��#ݳ�H�����t:�����w��G����^�+ ��U\ :��?��A�߻�'�m�O��>ҫ%����(���}����a�ڒ�D����������'�y��J��������
���޵u'�n�w~�~w����a�q����x�e@D�������I��v'�� ]Y�)e��Rt2�\k�/���P�m�W����?��KB���C+@�
����!���U����?\���:~oβNc��p��N.��������?���'�3������x����|l�3ϕ�Y%D>}l����,M�'��.�YC-��YXO��y���d����v�fV썹�H�*[�{��똣A����y�jG���P8��������m����O�ۯ�L&Gm|/l~�m׈ۡ�yB�GS'��d����-��{��y�h���^�xr��Ǯ��wz׈RR̦�4)��!Ue�
���#��xe���ԧ��i��ij�2b�tv�Y���4�����e���{Z�@����_-�����^�)Qe�����'��.���O���O�������@�eq��U�����j����?�_j����	��OD����o��ۗ���^��'�>�=?�qM3Wq�v�7����_����_���Ϻ��e=�V��o;)Ӑ'>~R�U8�ĕm����U�=���h��Ъ�r���9�U5�1��$v�m��ٛ;?EK�h���쩬G�Zׇ���Ou��� �<�k�%�B�\M����[��m|���:�52���h���EgI�PJ��d��'�N0�h**���=�D����5IA��+&�ܰ���:���xv).�õ11���W�B�a����@�-�s�Ov!�� ��������ī��S���KA��:�1&�Q�4@ilJ��O�Jq��!�>l4��L�~�PG�h��?�:�����������ϊ��-N������A#Y���]���5�5�c�^���6��%��d٩�9���ї�!�r���􀉩�L�]w����1�$����l�HQɱ$9�>�?���O�)��fpR�i��ߋ:��!��:T|�߯��[)�p����:Ԃ�a��2Ԁ����2������_u�����0e��ɍ�f1������S�v�ݝl��(+̒í���ݓ�b�oƌg�3�åFG�9Gf��xrIt��(#�c"9C�q^�B{vh��h��y�G�̣ٴ}���ｨ����"���x����7��_��U`���`������W���
�B�1̝�#p�e�-���������WD��1�=I�˧�]��tQI��Oo���� C.jk�3g  O�� ȟ���3 .R5P��`�?T����7� ���,!��7�}BhE������͐~���N�v[��eIE,��a��Ƽ<m0���|i'�rν�7s����f��� G"�|��F��S���==_�z�鴄\.��N��p��xǁ=����(ꇆr
��b�~�	�b�D*��a�2�t�L��Ӝ�BClm��;V�Ǘa���'�.��*5T��V��:E 4&�-��d&���г�vH�٢��car��Jz�Y$h~�_'z�����ͣ�``��yiw�팯��A�F>�$�2������	������V�����
�?�@�G�`�������W[���?���4������!���!����'��+B)��<��<��Q�E��7��P��<��I.dP�fC���� <ǧ,�L�y��b秡����_�?��W���=��,�ԡ&�k���pȋ'��ɹ��m�dbR����5��q���e�BO6�⢇m�=6��YB/���n�Cqyn�֣�Fy�\	�<����88��D�t[�������u��c����)���׈���%��P�����O��e��O���0�W��o��!㽎 �����/W��*B���_��?h�e����4�e����k�7����fh4�Ӧ���1'�re��E%�����eܘ#?3�}}����k+����<����Q��N��"o�~+V;	&�,O����1��D-�=-͑����Mw92��3�x����ǔθ���kX������vI��D���m���\{��s���ڶ#����z�zFP���\[oӵ����P�E�1ޡڤ�#^�Q5E2�L�h�ۓ�d���F\s�q��R��9��;��f�F����蜧I+�SOVs�c2�����g����p|�ǲKC��E��������P�m�W��1�_+B����uC����4�� �a��a�����>O��WX ���_[�Ձ���_J���/��jQ�?��%H��� ��B�/��B�o�����(�2����Cv��U?O�c�q�?R��P���:�?����?�_����c�p[�������?��]*���������?�`��)��C8D� ���������G)��C8D�(��4�����R ��� �����B-�v����GI����͐
�������n���$Ԉ�a-�ԡ���@B�C)��������?迊��CT�������C��2ԋ�!�lԢ���@B�C)����������� ���@�eq��U�����j����?��^
j��0�_:�P���u�������u	�S�����?�_���[��l��B(�+ ��_[�Ձ��W�8��<ԉ�1�"}4dh�K����Y@�l��8^H�f�$x�x��1��y$I1��>�����O����O��/�4yr���������4��ހiF(��ݮ�%q���>��=~�Z�84��ju\��0(����o�<?���t�A�;ˢ�L��kq�4�0B���9��L�V!�۸G�|�q��`����)9�sWj�h�}�������IU���u��C�gu����_A׷R����_u����Oe��?��?.e`�/�D����+�~@�ԩ���y���Rd���B���O��r��-�ڟ�T�x/��.���ZE��5l|����xu���x�"�!��(<a���m:����J1��'�������x�s��ԃ��,�s�2��{/�q��;��ߒP�����~���߀:���Wu��/����/����_��h�*P�w��?��A�}>�����?��:ɐG��Xc3[Y!2��\���_�����U�I�+�
����:yO��v��2��fC:.�-MZ�I�Gh#���oG��Φ��Ҏ�ҍF4:�ȑ"mA/���s���9�FtJ�g{F�+I��k�Q��J_3��.�x��7�����彰"�%\�w��ב7�z�Ƿ�Q��8$�Ŋ��
�:RY1�=��e�h���@��)�m��;[N��g��c��٩����!�>uO��:���]��`<%����F�վ1�x<����j��-�l�6)�l�����?���n�^�^�������R�����?~�������:�� ���K�g���`ī�(���8��(� ���:�?�b��_�����Ϲ���Q?����������H���+o��-����=�C7�k3݌c�c�Н�=B�������?Zo��?D�u�4ɕg�M���[�t�|��]ɟ,?��~�,?��g�r�������KO��u9�Z�W��Z��9�dd�/N�*|w]uAȯuVgC��0�Ĵ��+�/#}J[��2��t��b��F8{tMK�p�h�)�xΚMJ�w1�^9N2�+Ī`�a��.��|l��-�d�=�o����]].k.D��5/����<}�}y�l7u��=1�"3D�q�{K4s�)r/��&7�α�6��"�O��C����W.sd�yI��X����b,";��5�x���c���k�\�T�%V#R#!v���[�	z��~��io�+7%ru�]7qVOZ��������������oI(G�1>��4Fx>3c1��`��a��J�(N�fC��#�� }�B4�����Y�C�?��0�W
~���DG3���j?�W>���t7����8���O�)u6������˕?��#r�V`����������@���H���@������RP����������G���Ѡ�J�[�_����w�OݳǞ��B_�����,���<�\�/�[/urN=yW������6����w���wxc]pn�_����l?�}��I�{�m
�j3Z�;)퇭��pt��)�ƌ�U�I��Ѿk��ŵY����K�;�u��j�^m?䣾���C�~�/�X��Q�;3�!���d˫��,MZV2��dY������qx^�Ǌ��sg�b��r9�]J�������N ���~o���)Ͱ�\؄sr6��;R����j��*3_����u������-%��)�� �YC���׎_@_���0��>�a���o��.���{8F]�X� ��Q���q��x�����|�J��զש��z��ڧ���8y��Ɖd;T�{�̛'Z�������Z�����ދ���_~?��1
�_������{����+e|����/��XK ��W����UJ���h�e��?�л�����/o��k�����Gs�i���6�C�+��^�������?8�������}l��v6��[�H ǒ-�49�lH˳�J.��ϏI�ˇ�{�\!m]�:W��ѕ~����e���G����{���&�����+�9�S疧��<��ɭT���[�r �(�������Ig&�f��T%m7����^k��~]	/�e���Z<-�Q�k�hok��C����`��*]�훭��;ݡo�O�U���ރ���fV�XN�v����i�"f-��O��V�^)�e
M!>��X=��(5!n��}��ԍO�ǛC���n�Q�Z����֮��ۆ-)M��hq�UF�$�͋R]�䀽���ڮaLJS��L�>^�s�������EK�7�v֬���@p�2`Jr]�VR�Q��`�1����Z�$E���z%��3�o����������?��E�oh�����o��˃���O��R�!4������䋐��	�	��	�0���[���9�0�K���m�/�����X��\�ȅ�Q�-�������ߠ�����`��E�^��U�E�����	�6�B�����P�3#������r�?�?z���㿙�J��qA���������������2��C]����#����/��D��."�������P�!������K.�?���/�dJ��B���m�����E���Ȉ<�?d��#��E��D���C&@��� ����������u!���m�����GFN��B "��E��D�a�?�����P������0��	(��б!�1��߶���g�����Lȇ�C�?*r��C�?2 ���!��vɅ�Gr0������<��������۶���E�����2"�op4E��^��f����U�Mư��U,��ɗL�`8ò���la�,�|�#9�c�V��OO���]����/��NO%nިN���.�U�)6e��M���.K���Ze2�ұ�n�����N�"Yяi����m�A�e�B;b��ўl7�EOH��M�j�h��N�� n�����ڡ�P�̹֒ʐ{��i��_�zs��صj�Q�(�������`�$�4ڃ�����߻�(��3���C�Ot����5���<�����#��?�@����O�@ԭp��A���CǏ��D�n�����cb"�X�7
q�0�qܲ���-񻨶������ר�V�y�=Xmt#�z䶶�P������G8گ���~��[��Al�p�jb�]#y5�.ձ����ăj�BO����/��/"P���vo?c����E��!� �� ����C4�6 Bra��܅��� �/�Y����k���-;
j~h{Z�*��*�y����j�n�}>ŊXg2��+�+;P�}=؆�mHE�^o�eI�m�g�q��������mݝ��Hƅ��[>$�9v*x~91ɼ�d�i�Z��6���/j]mW)��C�a���^�M�9[g�p����a^E�?�r�a��5فhWkbר<�)�SQ����^m��9�@��/��onVՊ�د��^�|��OIl���TJ8�Z�6p)�+���*��.��T�B�p�i)�J�R+aBr]|��7KC�h�]�8.n2���M�~z��%y��(�?����� �#�d��k����A!�#r�����/�?2���/k�A������O��?˳��Y�T��$0�p����#��J���dr��8궸E@�A���?s%��3!O�U �'+��������o����P��vɅ�G]��/���$R���m�/��? #7��?"!�?w��KA�G&|3���h��?���oBG��c���&��2.�?�A��F\�>���c�G�X������c�G�a؟��HS?�W��N���9������<���.�[t�~�+��Z��q�*~Ǭ-�X��0�}c^�P���T�i��l���i,N�6�i��G�#�%k|�lj��(�:J�~�?������]�����i�a;�ВҨ��&{[A��ʴ��cA��NB���+8��Ld�,��͈"�gV��$mm�Չn�Yck$Gm���O�݊E�5��,����XY�a(�u��
�X�΀A.�?��Gr���"��������\�?��##O���F2%����_��g����_P�������Ar���"ਛ�&�����\�?K��#"G�e xkr��C�?2���W*i������v�5�H8�\�-{М���������X���'Z{c�[���9M��r ��_>� ���V���64z�()� 8�S�Y�o���6mћ���fH`J��JT�O�ޢY-ڨ�E.no���,+�È�� ,M�39 X��{9 �X�{�b��¢\��.��J��/L�sUl��G!]X����m�ɲޕ�˛����ȤV�kJgi�8�M��
�5���X_�?���Ʌ�G]Y��er���"�[�6�����<���R����������V�-���\��y��i�%u��)��h�,�M�2,R�I�bS�9�\��9�}�����Ƀ�_[�����G��9�g|�aܒ�0���	��i@�4j9���ɬ�V�U͜F�������ћ�Dco?ЪAl�����z��+V��]Դ�~?W�Sɡ�Ӱ�F�A����:1�'U�
.q��rٍ&���k�C��?с��O�B� 7N���Б���d ���E 7uS�$y�����#�?�[�˚ޑU���X�X1�x)��~�!������؉��g���KGv;li��+L�a�2kB���Ƙ���د��	Y�z��c�=����Q[����Y{����К\��������by��,@��, ��\�A�2 �� ��`��?��?`�!����Cķ�qj���g��aa����w,�.��q4ܒ�EH�_��{��������x�PX��N[W�h�i݂��~A���?�w�n�5sTnQ��T�VD�X�J|t��$,6ŶZ(��=4?T�:U�Z۶�^J�������v��	q��d牏ת4�(v�u!N�CY�kbܔ����%��D'�O�Æ_*�n4��RU�t�@�-���c�]E$cL=��'J�Yx� �iV���6�KCz��?m[~���
�4�zu�y=�n�|ِ��|r�S�p\۳c�X^������H�1X�F9zXp{j��6F�����ݝ�L�*N��_�`�n�_xq��;g=���볿��$��_�?ͤ���g��;�MO������S���������mE=�^�5A�)�G�&������q;������g9k�����T���	���v���ĵg���O�ם}�~��~���Bs]s�|()0������������?�V*��槿��}c^���OIT{�r.��3�1�Gq�W�4ͧ����=�/Bw\B�������\�r�0�� ���~��������yx��f�ߙ��=32�ds�9�]`bBO�����6��l��Y4�&n��L�7w�do/8b�������O$����/�Я췇=���������w������<y�{|�/�~}��i���>��'*�
�y~g]�O|���q�N��?�0;���WkI�Z^�׏��͹m��q�#|����В�{ֹ�C<^$��\�qm|��[��;�'���Ŀ��@�>�f�=|��Z�Orw��3������ھ�b��4��ܚ��Y`�_�d��99��}��{/���N�㟟�Ǎ�!�<��x��x�%��Z���&�� ��x���|z��縿uJI�����/��.��v���S��>6��ݪ)�c'wqi�.LE�v�ן����U�LO�N��ҟ���>��'��o��                           .���� � 