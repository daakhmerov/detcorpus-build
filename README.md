# ДЕТКОРПУС

Корпус русской прозы для детей и юношества XX—XXI вв. (ДетКорпус) —
это аннотированный корпус произведений русской детской литературы.
В настоящий момент корпус включает произведения, написанные в период
1900-х — 2020-х гг. Корпус создан как инструмент для исторических,
типологических и количественных исследований в области детской
литературы. Представленный датасет включает метаданные, а также
автоматически сгенерированную грамматическую и тематическую аннотацию
к текстам произведений, но не включает самих текстов произведений в
оригинальной форме. Формат и набор данных, включенных в датасет,
подобран таким образом, чтобы на этом материале можно было
воспроизвести большую часть статистических расчетов, сделанных на
исходных текстах корпуса, а также проводить новые количественные
исследования, опирающиеся на грамматическую и лексическую статистику.

Онлайн-интерфейс для поиска по исходным текстам корпуса свободно
доступен для исследователей, библиотекарей, учителей и всех
интересующихся детской литературой по адресу
http://detcorpus.ru. Интерфейс позволяет осуществлять поиск по
отдельным словам и по сложным запросам, знакомиться с контекстами
употребления поискового слова (фрагменты до 1000 слов), вычислять
частотную статистику по текстам и метаданным и строить выборки
примеров по комбинации критериев. Данные, содержащиеся в настоящем
датасете, соответствуют данным, отображаемым при поиске в корпусе на
http://detcorpus.ru.

При цитировании результатов, полученных при поиске по корпусу на
http://detcorpus.ru, мы рекомендуем указывать ссылку на текущую версию
настоящего датасета. Такое цитирование позволит в дальнейшем проверить
и при необходимости воспроизвести количественные результаты исследования.

## Выборка

Деткорпус включает 2703 прозаических произведения, написанных на
русском языке в период с 1900-х по 2020-е годы и адресованных детям и
подросткам. Корпус делится на две части: подкорпус художественной
литературы (2573 произведений) и подкорпус нон-фикшн (130). В корпус
включены только оригинальные произведения, написанные на русском
языке, переводные произведения в корпус не включаются.

Корпус отражает произведения, выходившие отдельными книжными изданиями
или включенные в сборники. Произведения, публиковавшиеся только в
периодических изданиях, в корпус не включены. Выборка произведений
для включения в корпус строится на основании библиографических
источников, маркирующих издания как адресованные детям и подросткам.
Для советского периода основанием теоретической выборки выступает серия
указателей «Детская литература» (1918—1984) И. И. Старцева и его
последователей. Выборка по постсоветской текущей библиографии строится
с использованием различных библиотечных и издательских каталогов.

В настоящий момент выборка включенных в корпус произведений не
является сбалансированной и не может рассматриваться как
репрезентативная по отношению к генеральной совокупности произведений
детской литературы означенного периода. Основным ограничением,
влияющим на состав выборки, является доступность цифровой копии. 
Корпус постоянно пополняется, ведется работа по улучшению
репрезентативности и балансировке корпуса.

## Метаданные

Все тексты корпуса сопровождаются метаданными об авторе и издании.
Сведения об авторе включают минимальную биографическую информацию:
имя, настоящее имя (если произведение опубликовано под псевдонимом),
годы жизни, пол.

Для каждого текста даны библиографические сведения о двух изданиях:
первом книжном издании произведения, а также издании-источнике
электронной копии, включенной в корпус. Для небольшой части случаев
указывается первая журнальная публикация вместо книжной. Это
характерно для ситуаций, когда первое книжное издание слишком далеко
отстоит по дате от первой журнальной публикации. Включение сведений о
первом издании позволяет привязать произведение на хронологической оси
к моменту, близкому к созданию произведения и/или его первой
публикации. Эту привязку можно использовать в том числе в
статистическом анализе и при визуализации данных корпуса.

Источниками метаданных служат преимущественно marc-файлы центральных
библиотек, а также метаданные цифровых копий. Метаданные корпуса
организованы в таблицу в файле metadata.tab.

Таблица **metadata.tab** содержит следующие колонки:

* filename — название файла в корпусе, служит для связи текста с 
  метаданными произведения в таблице;
* author, realname, author_birth_year, author_death_year, author_sex — 
  информация об авторе или авторах;
* title — название произведения; 
* year — год первой книжной публикации (для случаев, когда первое
  книжное издание далеко отстоит по дате выпуска от момента создания,
  используется год выхода журнальной версии), для многотомных изданий
  указан год издания конкретного тома;
* edition_year — год публикации источника корпусной копии; 
* firstprint_description — краткое библиографическое описание первого
  издания;
* edition — краткое библиографическое описание источника корпусной копии;
* genre — жанровая метка, если произведению присвоено более одной
  метки, они указываются через двоеточие; расшифровку значения меток
  см. ниже;
* id — уникальный идентификатор текста в корпусе, является производным
  от имени файла. Служит для идентификации документов и фрагментов 
  в lda-моделях, указывается в заголовках vert-файлов.
  
В Деткорпусе действуют **жанровые метки** (колонка «genre»). Жанровые
метки не имеют цели строгого дефинитивного разграничения произведений,
и служат практическим целям тематической сортировки или изучения
«формульных» текстов. Назначая произведениям жанровые метки мы
ориентируемся на исследовательскую, издательскую (серия,
подзаголовок), библиотечную (каталогизация) практики жанрового
определения, учитывая также авторскую и читательскую
(онлайн-сообщества) оптики. К моменту первой публикации корпуса
присвоение меток — «ручной» процесс, и его результаты до известной
степени субъективны, хотя и учитывают мнения экспертов и практиков.

Расшифровка значения жанровых меток:

* realism — Реалистическая проза, охватывает советскую и постсоветскую
  детскую литературу.
* detective — Детский детектив, произведения преимущественно 1990-х —
  2000-х гг. 
* fantasy — Фантастика, тексты, содержащие фантастические сюжетные
  элементы. 
* skazka — Литературная сказка, советский и постсоветский период.
* love — Любовные повести, современный роман для девочек (с 2000-х
  гг.). 
* horror — Ужастики, подкорпус страшной детской книги (с 2000-х гг.). 
* school — Школьная повесть, произведения, объединенные школьной
  топикой. 
* animalistic — Зообеллетристика, проза о животных, произведения, 
  в которых главные герои и мотивы связаны с животным миром.
* biography — Биографическая проза, основу сюжета составляет биография
  исторического лица.
* adventure — Приключенческие повести, произведения с приключенческой
  фабулой.
* history — Историческая беллетристика, литературные тексты об
  исторических событиях.
* nonfiction — Нон-фикшн: научно-популярная, просветительская и
  рекомендательная литература для детей.
* encyclopedia — Энциклопедии для детей.
* girls — Консультационные книги для девочек.

Большинство жанровых меток не являются взаимоисключающими. Произведению
может быть присвоено более одной метки, в этом случае значения
разделяются двоеточием.

## Тематическое моделирование (LDA)

В Деткорпусе реализован поиск по фрагментам произведений, содержащим
определенную тему и по словам, отнесенным к определенной
теме. Тематика определяется автоматически с помощью алгоритма
тематического моделирования LDA. В связи с тем, что корпус регулярно
обновляется и пополняется, результаты работы алгоритма (списки тем)
будут различаться для каждой новой публикации корпуса, хотя часть тем
демонстрирует некоторую устойчивость.

В ходе тематического моделирования построены три модели: на 100, 200 и
300 тем. Тематические модели строятся для всех текстов корпуса, без
разделения на подкорпуса художественной литературы и нон-фикшн. В
модель не включаются слова, относящиеся к служебным частям речи,
слова, помеченные MyStem как имена людей (граммемы имя, фам, отч), а
также несколько наиболее частотных в художественной прозе глаголов
(сказать, мочь, знать, становиться) и слово «человек».
Темтическое моделирование выполнено с помощью программы mallet
(http://mallet.cs.umass.edu/index.php)

В датасете в каталоге lda представлены пять типов файлов для каждого
из этих наборов:

**labels{100,200,300}.txt** — пронумерованный список тем с выводом
первых трёх по частотности слов (название темы). Темы в списке
отсортированы по убыванию размера (общее количество токенов,
отнесенных к теме в корпусе). В первой колонке содержится порядковый
номер темы по убыванию размера (совпадает с нумерацией тем при поиске
в корпусе). Во второй колонке — номер темы, присвоенный автоматически
при построении модели, совпадает с номером темы, используемым во всех
остальных файлах далее. В третьей колонке — три наиболее характерные
слова темы (автоматическая метка темы), совпадает с меткой темы при
поиске в онлайн-корпусе.

**summary{100,200,300}.txt** — расшифровка темы: пронумерованный
список тем с первыми пятьюдесятью по частотности словами в ней.

**diag{100,200,300}.xml** — диагностическая информация по каждой теме
в формате, предлагаемом утилитой mallet.

**doc-topics{100,200,300}.txt** — доля тем в каждом фрагменте всех
произведений корпуса. Последовательность колонок: 

* порядковый номер документа (фрагмента);
* идентификатор документа (совпадает с идентификатором в метаданных и
  в именах файлов);
* порядковый номер фрагмента в произведении;
* Далее список пар: 
  * номер темы (присвоенный автоматически при построении модели,
    вторая колонка в файле labels.txt);
  * доля темы во фрагменте. 
Приводятся данные только по темам, доля которых в указанном фрагменте
превышает 5%.

**topic-phrase.xml** — список частотных слов и биграмм в каждой теме,
в формате mallet.

## Аннотированные тексты произведений

Для публикации Деткорпуса в качестве датасета аннотированные тексты
произведений представлены в виде списков лексем с «перемешанной»
последовательностью предложений. Такая презентация текста обеспечивает
требование к воспроизводимости результата исследования: сохраняет как
лексические единицы, так и большую часть синтаксических конструкций,
однако не позволяет полностью воспроизвести оригинальный текст.

Аннотированные тексты произведений представлены в виде отдельных
файлов во включенном в датасет архиве texts.zip. Имена файлов
соответствуют идентификаторам, указанным в колонке filename в таблице
метаданных. Файлы с расширением .vert представляют собой текстовые
файлы в кодировке UTF-8. В файлах содержится два типа строк: 
* теги, разграничивающие структурные элементы текста (документ,
  фрагмент, предложение) и их атрибуты (метаданные), такие строки
  начинаются с символа <;
* табличные данные, содержащие словоформу, лемму, частеречный тег,
  грамматическую информацию в формате значений, разделенных символом
  табуляции (tab separated values).
  
Общая структура каждого .vert-файла следует обозначенной ниже схеме:

```
<doc id="идентификатор_документа" ...[другие метаданные в формате ключ="значение"]... >
<f id=1 lda100="..." lda200="..." lda300="..." >
<s>
<s>
Пытлив  пытливый        A               ед|кр|муж       8_жизнь_душа_мир        87_год_герой_жизнь      34_лицо_всегда_вид
и       и       CONJ
деятелен        деятельный      A               ед|кр|муж       8_жизнь_душа_мир        1_время_день_первый     34_лицо_всегда_вид
...»    ...»    c
</s>
. . .
</f>
</f id=2 ...[сведения о темах LDA, присутствующих в данном фрагменте]...  >
. . .
</f>
</doc>
```

Расшифровка значений тегов: 

* <doc> — документ корпуса, в качестве атрибутов тега указываются все
  метаданные текста (произведения) в формате key="value".
* <f id=N> — 500-словный фрагмент произведения, фрагменты используются
  при построении тематической модели LDA (подробнее см. ниже), а также
  при рандомизации данных — предложения документа «перемешиваются» в
  случайном порядке в рамках одного фрагмента. В качестве атрибутов
  тега указываются сведения обо всех темах каждой из тематических
  моделей, которые приписаны не менее чем 5% слов данного
  фрагмента. Формат: название_модели="список_тем,_разделенных_знаком_|".
* <s> — предложение, может не совпадать с границами синтаксических
  предложений в тексте, выделены автоматически с помощью программы
  MyStem (https://yandex.ru/dev/mystem/).

Последовательность полей в строках с данными по отдельным токенам: 

* Словоформа;
* Лемма;
* Частеречный тег. Используются теги, присвоенные программой MyStem в
  режиме автоматического снятия омонимии. Знакам пунктуации присвоен
  тег "c" (латинское c), числам — тег "NUM". Токены, не являющиеся
  словом, числом или знаком пунктуации (например, отсылки к
  примечаниям, разделители частей текста, математические формулы и
  выражения и т.п.), получили тег "UNK".
* список постоянных грамматических признаков лексемы (значения,
  разделенные символом |);
* список значений изменяемых грамматических признаков словоформы
  (значения, разделенные символом |);
* поля, содержащие метку темы, присвоенной данному слову в ходе
  тематического моделирования. В настоящей версии датасета таких полей
  три, по числу построенных моделей: lda100, lda200, lda300.

Вся грамматическая информация вычислена автоматически с помощью MyStem
с использованием встроенного механизма снятия омонимии. Расшифровку
обозначений граммем
см. https://yandex.ru/dev/mystem/doc/grammemes-values.html

## Гарантии целостности данных

Согласованность включенных в датасет метаданных, текстовых данных и
тематических моделей контролируется с помощью автоматизированных
тестов. Исходный код тестов включен в датасет в каталоге
test. Успешное прохождение всех тестов является условием публикации
данных или их обновления. 

Тесты обеспечивают следующие гарантии целостности метаданных:

* У каждого включенного в корпус произведения указан автор — в колонке
  author нет пустых значений. В настоящий момент корпус не включает
  безавторских и анонимных произведений.
* У каждого включенного в корпус произведения указан год первой
  публикации — в колонке year нет пустых значений.
* У каждого включенного в корпус произведения указана как минимум одна
  жанровая метка — в колонке genre нет пустых значений.
* Используются только описанные в настоящем документе жанровые метки
  (см. раздел Метаданные) — в колонке genre нет значений,
  отсутствующих в списке жанров.
* Идентификаторы документов являются уникальными — в колонке id нет
  повторяющихся значений.
* В таблице метаданных нет дублирующихся пар «автор—заглавие произведения» — 
  (колонки author и title).
* Для каждой строки в таблице метаданных в архиве texts.zip
  присутствует соответствующий .vert-файл произведения. 
* Для каждого .vert-файла произведения в архиве texts.zip имеется
  соответствующая ему строка в таблице метаданных.
* Для каждого документа в lda-моделях имеется распределение тем —
  каждый id из таблицы метаданных присутствует в таблицах
  doc-topics{100,200,300}.txt.
* В таблицах распределения тем doc-topics{100,200,300}.txt
  присутствуют только документы, описанные в метаданных — каждый id из
  таблиц doc-topics присутствует в metadata.csv.

Пользователь, скачавший датасет целиком, имеет возможность запустить
тесты и проверить корректность полученных данных с их помощью. Для
этого необходимо перейти в каталог с данными датасета и выполнить
команды:

```
python test/metadata.py
python test/lda.py
```

## Историческая справка

Формирование корпуса началось в 2017 г. Первоначальную основу корпуса
составила небольшая выборка из сотни школьных повестей 1950-х — 1980-х
гг. Впоследствии выборка текстов в корпусе последовательно расширялась
как в отношении периода создания произведений, так и жанров.

В 2018 году был опубликован первый релиз Деткорпуса, сформированный
преимущественно на основе литературы 1950-х — 1980-х реалистического
жанра, включавший около 500 произведений. В эту версию корпуса вошли
произведения, для которых были доступны цифровые копии из свободных
источников. Для аннотации Деткорпуса была создана библиографическая
база данных, которая отражает сведения об изданиях и авторах. В
октябре 2018 года поисковый интерфейс корпуса перенесен на сайт
http://detcorpus.ru. С тех пор корпус регулярно пополняется и
обновляется с периодичностью один-два раза в год.

## Участники проекта и благодарности

Публикация корпуса — результат коллективных усилий многих людей и
поддержки различных организаций. Концепцию корпуса, принципы
построения выборки и аннотации текстов сформулировал Кирилл
Маслинский, он же занимается организацией и развитием цифровой
инфраструктуры корпуса. Текущую библиографическую поддержку и
консультирование ведет главный библиограф корпуса Любовь Алейник, она
же составила первоначальное «ядро» коллекции и сформировала
постсоветский подкорпус. Евгения Лекаревич выполняет основную работу
по пополнению и балансировке корпуса, аннотированию метаданных,
исправлению ошибок и подготовке корпуса к публикации.

Качественный переход корпуса из узкой тематической коллекции в большой
и достаточно репрезентативный корпус детской литературы стал
возможен благодаря деятельному энтузиазму участников студенческого
проекта по развитию корпуса НИУ ВШЭ Санкт-Петербург Екатерины
Додоновой, Юлии Кожевниковой и Никиты Никифорова, которые значительно
пополнили корпус текстами на раннем этапе его развития. Наши
коллеги-исследователи Катя Сенне и Лора Тибонье помогли сформировать
ряд тематических подкорпусов. Подробнее об участниках проекта и их
вкладе см.  http://detcorpus.ru/pages/about.html.

Институт русской литературы (Пушкинский Дом) РАН оказывает огромную
организационную поддержку проекту, а также предоставляет хостинг и
вычислительные ресурсы для работы корпуса. Сотрудничество и поддержка
со стороны Российской государственной детской библиотеки позволяют
пополнять корпус, в том числе текстами редких и труднодоступных
изданий. Мы благодарны Валентину Головину и Илье Гавришину,
поддерживающим нас от лица этих организаций. 