#!/bin/bash

#PBS -N N_M_R_dy 
#PBS -A URTG0033
#PBS -l walltime=12:00:00
#PBS -q regular
#PBS -j oe
#PBS -k eod
#PBS -m abe
#PBS -M pengfeiwang@psu.edu
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1

for year in 2017 #2019
do

DIR3=./output/${year}/pm25
 if [ ! -d $DIR3 ] ; then
    echo "Creating output directory $DIR3"
    mkdir -p $DIR3
 fi

for mm in Jul_cb05 #Jul_radm2 #Apr Jul Oct
do


DIR1=/glade/derecho/scratch/pwang/postprocess/05_extract/wrfchem_ts_results/2017/${mm}/daily
DIR2=/glade/work/pwang/run/NEI_2017/postprocess/05_extract/EPA_obs/Jul/daily

#for scen in edgar_new2;do

#for spec in O3_1h O3_8h CO NO2 SO2; do
for spec in PM25 #NO2 SO2;
do
for city in 010030010	010270001	010331002	010491003	010530002	010550010	010690002	010690003	010730023	010731005	010731009	010731010	010732003	010732006	010732059	010735002	010735003	010736004	010890014	010970002	010970003	010972005	011010007	011011002	011030010	011030011	011130001	011130003	011170006	011190002	011190003	011210002	011250003	011250004	011270002	040011235	040031005	040051008	040070008	040128000	040130019	040131003	040131004	040132001	040134003	040134005	040134009	040134019	040134020	040134021	040137002	040137003	040137020	040139812	040139990	040139991	040139992	040139997	040151000	040190011	040191028	040210001	040213002	040213013	040213015	040217001	040230004	040252002	040270004	040278011	050010001	050010010	050010011	050030003	050030004	050030005	050070002	050070003	050310001	050310005	050350004	050350005	050450002	050510002	050510003	050670001	050690005	050690006	050890001	050910001	050910004	050930007	051070001	051130002	051150003	051190003	051190007	051191004	051191005	051191008	051310008	051390004	051390005	051390006	051430003	051430004	051430005	051450001	060010007	060010009	060010011	060010012	060010013	060010015	060011001	060070002	060070008	060090001	060110007	060111002	060130002	060131004	060150007	060170011	060170012	060190008	060190011	060190500	060192009	060192016	060195001	060195025	060230006	060231002	060231004	060231005	060250003	060250005	060250007	060250010	060251003	060270002	060271003	060271018	060271023	060271033	060290010	060290011	060290014	060290015	060290016	060290018	060290019	060292012	060310004	060311004	060333001	060333002	060370002	060371002	060371103	060371201	060371301	060371302	060371601	060371602	060372005	060374002	060374004	060374008	060374009	060379002	060379033	060390500	060392010	060410001	060450006	060452001	060452002	060452003	060470003	060472510	060490001	060510001	060510005	060530002	060530008	060531002	060531003	060550003	060550004	060570005	060571001	060590001	060590007	060592022	060610002	060610003	060610006	060631006	060631008	060631009	060631010	060650009	060650010	060650500	060651003	060651016	060652002	060655001	060658001	060658005	060670006	060670010	060670012	060670015	060674001	060675003	060690002	060710014	060710025	060710027	060710306	060712002	060718001	060719004	060730001	060730003	060730006	060730077	060731002	060731006	060731007	060731008	060731010	060731011	060731016	060731017	060731018	060731022	060731026	060731201	060750005	060771002	060771003	060772010	060792002	060792004	060792006	060792007	060792020	060798001	060798002	060811001	060830010	060830011	060831007	060831008	060831009	060832004	060832011	060850002	060850004	060850005	060850006	060852003	060870007	060871004	060871005	060890004	060893004	060893005	060932001	060950004	060970003	060970004	060990005	060990006	061010003	061030006	061030007	061050002	061070009	061072002	061072003	061110007	061110009	061111004	061112002	061113001	061131003	080010001	080010006	080010008	080010010	080050005	080070001	080070002	080130003	080130012	080290004	080290007	080310002	080310013	080310017	080310023	080310025	080310026	080310027	080310028	080350003	080350004	080350005	080390001	080410008	080410011	080410017	080450019	080450020	080510005	080510007	080570005	080670008	080677001	080677003	080690009	080770003	080770017	080830006	080930002	081010012	081010015	081030006	081070003	081130004	081230006	081230008	090010010	090010113	090011123	090012124	090013005	090019003	090030025	090031003	090031018	090032006	090050004	090050005	090090018	090090026	090090027	090091123	090092008	090092123	090098003	090099005	090110124	090113002	100010002	100010003	100031003	100031007	100031008	100031011	100031012	100032004	100051002	110010041	110010042	110010043	110010051	110010053	120010023	120010024	120013012	120051004	120090007	120110033	120110034	120110035	120111002	120112003	120112004	120113002	120115005	120170005	120310032	120310098	120310099	120310108	120330004	120330025	120330026	120330027	120330028	120330029	120330030	120570030	120570113	120571075	120571111	120573002	120574004	120690001	120710005	120730012	120814012	120830003	120860033	120861016	120866001	120950009	120951004	120952002	120990008	120990009	120990022	120992003	120992005	121030004	121030018	121031008	121031009	121056006	121111002	121130014	121150013	121171002	121275002	130210007	130210012	130510017	130510091	130511002	130590001	130590002	130630091	130670003	130670004	130690002	130890002	130892001	130950007	131150003	131150005	131210032	131210039	131210048	131210056	131211001	131270004	131270006	131350002	131390003	131530001	131850003	132150001	132150008	132150011	132150012	132230003	132450005	132450091	132950002	132950004	133030001	133190001	160010010	160010011	160010017	160010021	160050006	160050015	160050018	160050020	160090010	160090011	160150001	160150002	160170001	160170004	160170005	160190010	160190011	160190013	160210001	160210002	160270002	160270004	160270005	160270008	160290003	160410001	160410002	160450001	160490002	160490003	160530003	160550006	160550014	160570005	160590004	160690009	160690012	160770011	160790017	160830006	160830010	160850001	170010006	170010007	170190004	170190006	170191001	170310001	170310014	170310022	170310050	170310052	170310057	170310076	170310119	170311016	170311701	170312001	170313103	170313301	170314006	170314007	170314201	170316005	170434002	170650002	170830117	170831001	170890003	170890007	170971007	170990007	171110001	171132002	171132003	171150013	171170002	171190023	171190024	171190120	171191007	171192009	171193007	171430037	171570001	171610003	171613002	171630010	171634001	171639010	171670012	171971002	171971011	172010010	172010013	172010118	180030004	180030014	180050008	180190005	180190006	180190008	180190010	180350006	180370004	180370005	180372001	180390003	180390008	180431004	180510012	180550001	180570007	180570008	180650003	180670003	180670004	180830004	180890006	180890022	180890026	180890027	180890031	180890034	180890036	180891003	180891016	180892004	180892010	180896000	180910011	180910012	180950009	180950011	180970042	180970043	180970066	180970078	180970079	180970081	180970083	180970084	180970087	181050003	181070004	181270020	181270024	181410014	181410015	181411008	181412004	181470009	181530007	181570007	181570008	181630006	181630012	181630016	181630020	181630021	181630023	181670018	181670023	181830003	190130008	190130009	190170011	190330019	190330020	190450019	190450021	190550001	190630003	191032001	191110008	191130036	191130037	191130040	191370002	191390015	191390016	191390018	191390020	191471002	191530030	191530059	191532510	191532520	191550009	191630015	191630018	191630019	191630020	191692530	191710007	191770005	191770006	191930017	191930019	191930021	191970004	200910007	200910008	200910009	200910010	201070002	201330003	201730008	201730009	201730010	201731012	201770010	201770011	201770012	201770013	201910002	201950001	202090021	202090022	210130002	210190017	210290006	210370003	210373002	210430500	210470006	210590005	210590014	210610501	210670012	210670014	210730006	210930005	210930006	211010006	211010014	211110043	211110044	211110048	211110051	211110067	211110075	211110080	211111041	211170007	211250004	211451004	211451024	211510003	211830032	211930003	211950002	211990003	212270007	212270008	212270009	220170008	220171002	220190008	220190009	220190010	220290002	220290003	220330002	220330009	220331001	220470005	220470009	220511001	220512001	220518105	220518106	220518107	220550005	220550006	220550007	220710010	220710012	220710021	220718105	220718106	220718109	220718110	220718401	220730004	220758400	220790001	220790002	220870004	220870007	220878103	220890005	221038400	221038401	221050001	221090001	221210001	230010011	230030013	230030014	230031008	230031011	230050015	230050027	230050028	230050029	230052003	230072002	230072003	230090103	230110016	230112002	230112006	230132001	230172011	230190002	230190017	230194003	230210004	230310008	240030014	240030019	240031003	240032002	240051007	240053001	240150003	240190004	240230002	240251001	240270006	240290002	240313001	240330001	240330002	240330025	240330030	240338001	240338003	240430009	245100006	245100007	245100008	245100035	245100040	245100049	245100052	245105253	250030006	250030008	250035001	250036001	250051004	250052004	250053001	250092006	250095005	250096001	250112005	250130008	250130016	250130018	250132007	250132009	250154002	250170008	250170009	250170010	250171102	250210007	250212004	250212005	250213003	250230004	250230005	250250002	250250027	250250042	250250043	250250044	250251004	250270016	250270020	250270023	250272004	260050003	260070005	260170014	260210014	260330901	260330902	260330903	260430002	260470004	260490021	260550003	260650012	260650018	260710001	260770008	260810007	260810020	260910007	260990009	261010922	261130001	261150005	261150006	261210040	261250001	261390005	261410901	261450018	261470005	261530001	261610005	261610008	261630001	261630015	261630016	261630019	261630025	261630033	261630036	261630038	261630039	261630093	261630095	261630097	261630098	261630099	261630100	261631013	270031002	270052013	270072304	270177417	270210001	270213410	270317810	270353202	270353204	270370470	270370480	270376018	270412110	270475401	270530050	270530909	270530960	270530961	270530962	270530963	270530964	270530965	270530968	270531007	270531901	270531904	270531905	270531906	270531909	270532006	270611105	270674110	270750005	270757608	270834210	270854301	270953051	271035109	271095008	271112012	271230021	271230866	271230868	271230871	271230872	271230873	271231902	271231903	271231907	271231908	271377001	271377549	271377550	271377551	271377554	271390505	271453052	271630301	271630445	271630446	271630447	271630448	271695220	271713201	280010004	280110001	280110002	280330002	280350004	280430001	280450001	280450002	280450003	280458104	280458105	280458108	280458201	280470008	280478101	280478102	280478103	280478106	280478107	280490010	280490018	280490019	280490020	280490021	280590006	280670002	280750003	280810005	280870001	281090001	281210001	281230001	281490004	290190004	290210005	290210010	290370003	290390001	290470005	290470026	290470041	290770032	290770036	290910003	290950010	290950034	290950036	290950037	290950041	290950042	290952002	290970003	290990012	290990019	291250001	291290001	291370001	291831002	291860006	291890004	291890015	291892003	291893001	291895001	295100007	295100085	295100086	295100087	295100093	295100094	300131026	300170005	300270006	300290007	300290009	300290039	300290043	300290047	300290049	300310006	300310008	300310013	300310016	300310017	300310018	300470013	300470028	300490004	300490018	300490019	300490025	300490026	300530018	300630012	300630021	300630024	300630031	300630037	300650005	300710010	300750001	300810001	300810007	300830001	300830002	300870001	300870307	300890007	300930005	301110085	301110087	301111065	310250002	310270001	310310001	310490001	310550019	310550051	310550052	310670005	310790003	310790004	310790005	311090022	311111002	311530007	311570003	311570004	311570006	311770002	320030022	320030024	320030043	320030044	320030071	320030073	320030075	320030298	320030299	320030540	320030560	320030561	320030602	320031019	320031501	320031502	320032002	320032003	320038000	320050007	320050008	320310016	320310022	320310025	320310031	320311005	320311007	320312002	325100020	330012003	330012004	330012005	330012006	330050007	330070014	330090008	330090010	330093002	330110019	330110020	330111007	330111010	330111015	330115001	330130003	330131006	330132007	330135001	330150006	330150009	330150014	330150018	330190003	340010006	340011006	340030003	340030007	340030008	340030009	340030010	340070002	340070003	340071007	340110007	340130003	340130011	340130015	340130016	340150002	340150004	340155001	340170008	340171003	340172002	340190001	340210005	340210008	340218001	340230006	340230011	340270004	340273001	340292002	340310005	340390004	340390006	340392003	340410006	340410007	350010023	350010024	350010026	350010029	350011012	350011013	350019004	350019013	350050005	350130016	350130017	350130021	350130022	350130025	350131006	350171002	350250007	350250008	350431003	350439001	350439003	350439004	350439005	350439011	350450006	350450019	350490020	350490021	350499002	350550005	360010005	360010012	360050073	360050080	360050083	360050110	360050133	360070009	360130006	360130011	360271004	360290002	360290005	360290023	360291007	360310003	360470011	360470052	360470076	360470122	360550015	360551007	360552002	360556001	360590005	360590008	360590011	360590012	360590013	360610010	360610056	360610062	360610079	360610128	360610134	360632008	360652001	360670019	360670020	360671015	360710002	360810094	360810096	360810097	360810124	360810125	360850055	360850067	360893001	360930003	361010003	361030001	361030002	361191002	370010002	370210034	370250004	370330001	370350004	370350005	370350006	370370004	370510009	370570002	370570003	370570004	370610002	370630001	370630015	370650003	370650004	370670022	370670024	370670030	370710016	370810009	370810013	370810014	370811005	370870010	370870012	370990006	371010002	371050002	371070004	371110004	371170001	371190010	371190034	371190040	371190041	371190042	371190043	371190045	371190048	371210001	371210004	371230001	371270002	371290002	371290009	371310003	371330005	371350007	371390002	371470005	371470006	371550004	371550005	371590021	371730002	371730007	371830014	371830015	371830020	371830021	371890003	371910005	380070002	380130002	380130003	380130004	380150003	380171004	380250003	380250004	380350004	380530002	380570004	380571113	380610115	380650002	380890002	380910001	381010003	381050003	390030009	390090003	390130006	390170003	390170015	390170016	390170017	390170019	390170020	390170022	390171004	390230005	390250022	390350013	390350027	390350034	390350038	390350045	390350060	390350065	390350066	390350073	390351002	390490024	390490025	390490029	390490034	390490038	390490039	390490040	390490081	390570005	390610006	390610010	390610014	390610040	390610041	390610042	390610043	390610048	390617001	390618001	390670004	390670005	390810016	390810017	390810021	390811001	390850007	390851001	390853002	390870010	390870012	390930016	390932003	390933002	390950024	390950025	390950026	390950028	390951003	390990005	390990014	390990015	391030003	391030004	391130014	391130031	391130032	391130038	391330002	391351001	391450013	391450015	391510017	391510020	391530017	391530023	391550005	391550007	391550014	391650007	400019009	400159008	400179001	400190294	400190295	400190297	400219002	400270049	400310648	400310651	400390852	400430860	400470554	400710602	400710604	400719003	400719010	400719030	400790467	400819005	400850300	400970186	400979014	401010169	401050207	401090035	401090038	401090097	401091037	401159004	401159007	401179007	401190614	401210415	401250054	401339006	401359015	401359021	401430110	401430131	401430174	401431127	401470217	410030013	410090004	410130100	410170113	410170120	410190002	410190003	410250002	410250003	410290133	410291001	410292129	410294001	410330011	410330107	410330114	410350004	410370001	410370003	410390058	410390059	410390060	410391007	410391009	410391061	410392013	410399002	410399004	410430009	410432002	410470040	410470109	410470110	410510080	410510244	410510246	410590005	410590121	410591002	410591003	410597002	410610006	410610117	410610119	410619103	410650007	410670004	410670005	410670111	410671003	420010001	420030002	420030008	420030021	420030064	420030067	420030093	420030095	420030097	420030116	420030131	420030133	420031008	420031301	420031376	420033007	420039002	420050001	420070008	420070014	420110009	420110010	420110011	420130801	420150011	420170012	420210011	420270100	420290100	420410100	420410101	420430401	420450002	420450109	420490003	420510524	420590002	420630004	420692006	420710007	420710012	420750100	420750101	420770004	420791101	420810419	420850100	420890002	420910013	420950025	420950027	420990301	421010003	421010004	421010014	421010020	421010024	421010027	421010047	421010048	421010052	421010055	421010056	421010057	421010075	421010076	421010136	421011002	421150215	421174000	421250005	421250200	421255001	421255200	421290008	421310010	421330008	440030002	440030014	440070020	440070022	440070023	440070026	440070028	440070030	440071005	440071010	440090007	450030003	450130007	450150005	450190006	450190008	450190009	450190020	450190021	450190046	450190048	450190049	450190051	450250001	450290002	450370001	450410002	450410003	450430009	450450008	450450009	450450011	450450012	450450013	450450014	450450015	450450016	450470003	450510002	450630005	450630008	450730001	450750002	450790007	450790018	450790019	450791001	450830010	450830011	450910006	450918801	460110002	460110003	460130003	460130004	460270001	460290002	460330132	460650003	460710001	460930001	460990006	460990007	460990008	460990009	461030013	461030014	461030015	461030016	461030017	461030019	461030020	461031001	461270001	461270002	470090005	470090011	470090101	470370023	470370025	470370036	470370040	470450004	470650031	470650032	470651011	470654002	470930028	470931013	470931017	470931020	470990002	470990003	471050108	471050109	471071002	471130004	471130006	471130010	471192007	471251009	471251010	471251011	471252001	471410001	471410005	471450004	471451001	471453001	471453005	471453006	471453008	471453009	471453013	471570014	471570024	471570038	471570047	471570075	471570100	471571004	471631007	471650007	480131090	480271045	480290032	480290034	480290052	480290053	480290059	480290060	480291069	480370004	480371031	480391003	480411086	480430002	480430101	480550062	480610006	480612002	480612004	480850005	481130020	481130035	481130050	481130057	481130069	481130087	481133004	481210034	481350003	481351014	481390015	481390016	481410002	481410010	481410037	481410038	481410043	481410044	481410045	481410053	481410055	481410057	481410058	481670014	481670053	481671005	481671034	481830001	482010024	482010026	482010046	482010051	482010055	482010058	482010062	482010066	482010075	482011034	482011035	482011037	482011039	482011050	482011052	482030002	482150042	482150043	482151046	482430004	482450021	482450022	482570005	482730314	483030001	483030325	483031028	483091002	483150050	483230004	483390078	483390089	483491051	483550020	483550032	483550034	483611001	483611100	483750005	483750320	484390063	484391002	484391003	484391006	484391053	484393006	484393010	484530014	484530020	484530021	484531068	484790016	484790313	490030003	490030004	490037001	490050004	490050005	490050006	490050007	490071003	490110001	490110004	490130002	490137011	490210005	490350003	490350012	490351001	490351007	490352005	490353003	490353006	490353007	490353008	490353010	490353013	490353014	490353015	490353016	490354002	490450002	490450003	490450004	490471003	490471004	490475601	490475632	490490002	490494001	490495008	490495010	490530007	490530130	490570001	490570002	490570007	490571003	500010002	500010003	500030004	500030005	500070007	500070012	500070014	500210002	500230005	510030001	510130020	510360002	510410003	510410004	510590030	510590031	510591004	510591005	510595001	510690010	510870014	510870015	511071005	511130003	511390004	511611004	511650003	515100009	515200006	515500012	516500004	516500008	516800014	516800015	517000013	517100024	517600020	517600025	517700014	517700015	517750010	517750011	518100008	530010003	530030004	530050002	530070006	530070010	530070011	530090009	530110013	530110020	530110022	530110023	530110024	530150015	530251002	530272002	530310003	530330004	530330017	530330021	530330023	530330024	530330027	530330030	530330033	530330037	530330057	530330069	530330080	530330089	530332004	530350007	530350008	530370002	530410006	530410008	530450004	530470009	530470013	530530024	530530029	530530031	530531018	530570011	530570014	530590002	530610005	530610020	530611007	530630001	530630016	530630017	530630021	530630047	530639000	530650004	530650005	530650009	530670013	530710005	530730015	530730019	530750003	530750004	530770005	530770009	530770012	530770015	530770016	540030003	540090005	540090011	540110006	540110007	540290009	540291004	540330003	540390009	540390010	540390011	540390020	540391005	540490006	540511002	540550002	540610003	540690008	540690010	540810002	540890001	541071002	550030010	550090005	550090009	550090025	550090026	550090028	550250025	550250041	550250047	550250048	550270001	550270007	550290004	550310025	550350014	550350100	550410007	550430009	550532002	550550008	550590019	550630012	550710007	550790010	550790026	550790043	550790050	550790051	550790056	550790058	550790059	550790099	550812001	550870009	550890008	550890009	551050002	551050024	551091002	551110007	551198001	551250001	551330027	551330034	551350004	551390011	551410016	560010006	560010010	560010011	560010012	560030003	560050800	560050877	560050886	560050891	560050892	560050899	560051002	560051899	560071000	560090009	560090801	560090819	560130004	560130099	560130232	560130900	560131003	560131004	560150004	560150005	560210001	560210002	560210003	560210100	560230004	560250001	560250005	560250100	560290001	560290003	560330001	560330002	560330003	560330006	560331003	560350097	560350101	560350700	560350705	560370007	560370023	560370100	560370870	560390006	560390009	560391006	560391013	560410101	560450004	800020012	800020014	800260006 

#for city in Beijing Shanghai Tianjin Shijiazhuang Guangzhou Jinan Wuhan
do
cat << EOF | ./stat_NMBE_MB_RMSE.exe
${DIR1}/station.daily.pm25_${mm}.2017.${city}
${DIR2}/julian_daily_obs.pm25.2017_Jul.${city}.txt
${DIR3}/${spec}.${city}.${year}_${mm}_daily_NMBE_MB_RMSE.txt
EOF
done
done
done
done
