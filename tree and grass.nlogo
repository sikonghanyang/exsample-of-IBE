;;以下、繁殖仅考虑周围八个个体，在有性生殖模式中极有可能死亡。
;;植物应当为雌雄同体
extensions [
  py
]
;智能体的基因型对应于其在适应度环境中的位置
breed [cao caos]
breed [tree trees]
globals [    Si  u Zi birth   i  ii color1 gene_path11 gene_path22 gene-path33 gene-path44 male
p  n inner element  first-half behind-half mix mix1 mix2 s1 s2 s3 s4 per]
;gene_set 是基因组 d  Si omega u 死亡判断的参数 Zi 个体表型 birth可出生个体数 Gene_path1/2 繁殖中传递的基因组

patches-own [agent gene1 gene2 gene_path gene_path1 gene_path2 phynotype environment life sex  a rain-local  huo]
to setup;默认所有patch上都有生物 sex=1 男性 sex=0 女性
  clear-all
  reset-ticks
  py:setup py:python
  py:run "import matplotlib.pyplot as plt"
  py:run "import numpy as np"
  py:run "from os.path import basename, exists"
  py:run "import random"



  set d 0.1
  set omega 0.5
  ask patches[
    set a random-float 1
    set rain-local rain + random-normal 0 0.025

    ifelse a <= 0.2
    [set pcolor white
     set gene1 py:runresult"np.random.binomial(1, 0.2,20)"
     set gene2 py:runresult"np.random.binomial(1, 0.2,20)"
     set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
    set color1 1]
    [ifelse a <= 0.4
        [set pcolor blue
       set gene1 py:runresult"np.random.binomial(1, 0.4,20)"
       set gene2 py:runresult"np.random.binomial(1, 0.4,20)"
       set phynotype  (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
      set color1 2]
        [ifelse a <= 0.6
          [set pcolor yellow
           set gene1 py:runresult"np.random.binomial(1, 0.6,20)"
           set gene2 py:runresult"np.random.binomial(1, 0.6,20)"
           set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
        set color1 3]
          [ifelse a <= 0.8
            [set pcolor red
             set gene1 py:runresult"np.random.binomial(1, 0.8,20)"
             set gene2 py:runresult"np.random.binomial(1, 0.8,20)"
             set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
          set color1 4]
          [set pcolor black]]]]
    set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )

    ;py:set "gene1" gene1
   ;loop[
   ; set i 0
      ;set gene1  (list random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025
      ;random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025
      ;random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025
      ;random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 )
    ;set gene1 []
   ; set a se gene1 a
    ;set i i + 1
    ;if i = 20 [stop]
    ;py:run "gene2 = np.random.binomial(1, 0.6,20)"

 ; loop[
    ;set i 0
     ; set a (random-normal 0.6 0.025)
      ;set gene2  (list random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025
     ; random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025
      ;random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025
      ;random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 random-normal 0.6 0.025 )
   ; set a se gene2 a
    ;set i i + 1
    ;if i = 20 [stop]
    ;ifelse random 2 = 0[
     ; set gene_path1 gene1]
    ;[set gene_path1 gene2]


     set life 1
    ifelse random 2  = 1
    [set sex 1]
    [
      set sex 0
      set birth 1
    ]
    if phynotype = 0 [set pcolor black]]
  ask patches[
    if phynotype = 0 [set pcolor black]]
end
to go
 ask patches[
    ;set color1 int(pcolor)
    set huo   (1 - d) * exp (-((phynotype - rain-local) ^ 2)/ omega )
    if random-float 1 < (1 - d) * exp (-((phynotype - rain-local) ^ 2)/ omega );0.1 + abs (phynotype - rain-local)注这个代码可能有问题，死亡率计算中出错了
    [set pcolor  black]
    if birth = 1 and sex = 0
    [
      if (count neighbors with [sex = 1 ] > 1)[;and pcolor = [pcolor] of myself ] >= 1 );and  pcolor = [pcolor] of myself >= 1);and count neighbors with [ pcolor = [pcolor] of myself] >= 1[
        set Gene_path2 Gene_path
        ;ask one-of neighbors with [sex = 1][
        if one-of neighbors with [pcolor = black] = true;  使用 foreach or map 方法
        ;ask neighbors[
          ;if one-of neighbors with [pcolor = ]
          [ask  one-of neighbors with [pcolor = black][
            set gene1 gene_path1
            set gene2 gene_path2
            set pcolor color1
            ifelse random 2  = 1
                 [set sex 1]
                 [set sex 0]
         ; ]
        ]
      ]
      ]
    ]

  ]
end
to rain-plus
  ifelse rain + 0.1 <= 1
  [set rain rain + 0.1]
  [rain-minus]
end
to rain-minus
  ifelse rain - 0.1 >= 0
  [set rain rain - 0.1]
  [rain-plus]
end
to died
      ;show "33";这里存在循环进不去的问题
      set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
      if random-float 1 > huo[
      set pcolor  black]
end
to go-sexual
  ask patches[set rain-local rain + random-normal 0 0.025]
  ;if ticks mod 1000 = 0
;[ ifelse random 2 = 1
   ; [ rain-plus]
    ;[ rain-minus
    ;]
    ;random-norm al mean standard-deviation
  ; do something
;]

  ask patches[
    ;show gene2
     if phynotype = 0 [set pcolor black];防止错误数据
    set rain-local rain + random-normal 0 0.025
    if pcolor != black[
      ;show "33";这里存在循环进不去的问题
      died
      ;set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
      ;if random-float 1 > huo[
      ;set pcolor  black]
   loop[
        get-color
    ;get-colorsim;获得color1，包涵斑块颜色。
      if sex = 0 [


       ifelse random 2  = 1
    [set gene-path33 gene1]
    [set gene-path33 gene2];赋值操作导致了原变量丢失？
        ;show gene-path33
        ;show "33"
if count neighbors with [pcolor = color1 and sex = 1] > 0[
      ask  one-of neighbors with [pcolor = color1 and sex = 1][;
      ifelse random 2  = 1
    [set gene-path44 gene1]
    [set gene-path44 gene2]
       ;show gene-path44
      ; show "44"
       ;show "2"
       ;show gene2
       set male 1

          ]


      ]
      ]
   ; set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
     ; if random-float 1 > huo[
     ; set pcolor  black]
      if male = 1 [
    if count  neighbors with [pcolor = black] > 0[
    ask one-of neighbors with [pcolor = black][
        anti-color
        ;anti-colorsim
      set gene1 gene-path33
         ; show gene1
        ;show "1"
          show gene-path44
      set gene2 gene-path44
        ;show gene2
        ;show "2"
     ifelse random 2  = 1
    [set sex 1]
    [set sex 0]

      set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
            set male  0;导致死亡过快。
             ;show "+1"

    ]



  ]
      ]
stop]
  ]]
  ;show "1"
end
to go-unsexual
    ask patches[set rain-local rain + random-normal 0 0.025]
    if ticks mod 1000 = 0
[ ifelse random 2 = 1
    [ rain-plus]
    [ rain-minus
    ]
    ;random-norm al mean standard-deviation
  ; do something
]

   ask patches[
    set rain-local rain + random-normal 0 0.025
    if phynotype = 0 [set pcolor black];防止错误数据
  if pcolor != black [
     ;show gene1
      ;show gene2
    set gene_path11 gene1
    set gene_path22 gene2
    ;set color1 int(pcolor)
    ;set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
    get-color
      ;get-colorsim
    ;if random-float 1 > (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega );0.1 + abs (phynotype - rain-local)注这个代码可能有问题，死亡率计算中出错了
    ;[set pcolor  black]
            set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
      if random-float 1 > huo[
      set pcolor  black]

      if count  neighbors with [pcolor = black] > 0[
        ask one-of neighbors with [pcolor = black] [
          anti-color
          ;anti-colorsim
          ;show "nihao"

          set gene1 gene_path11
          ;show gene1
          set gene2 gene_path22
          set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
    ]]]
  ]
 show count patches with[ phynotype = 0]
end
to go-plant
      ask patches[set rain-local rain + random-normal 0 0.025]
    ;if ticks mod 1000 = 0
;[ ifelse random 2 = 1
   ; [ rain-plus]
   ; [ rain-minus
   ; ]
    ;random-norm al mean standard-deviation
  ; do something
;]

  ask patches[
    ;show gene2
     if phynotype = 0 [set pcolor black];防止错误数据
    set rain-local rain + random-normal 0 0.025
    if pcolor != black[
      ;show "33";这里存在循环进不去的问题
      set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
      if random-float 1 > huo[
      set pcolor  black]
   loop[
        get-color
    ;get-colorsim;获得color1，包涵斑块颜色。
      if sex = 0 [


       ifelse random 2  = 1
          [ifelse per > 0.7
            [set gene_path11 gene1]
              [set gene_path11 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene_path22 gene2]
              [set gene_path22 go2 gene1 gene2]     ];赋值操作导致了原变量丢失？
        ;show gene-path33
        ;show "33"
;if count neighbors with [pcolor = color1 and sex = 1] > 0[
      ;ask  one-of neighbors with [pcolor = color1 and sex = 1][;
      ifelse random 2  = 1
                    [ifelse per > 0.7
            [set gene-path33 gene1]
              [set gene-path33 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene-path44 gene2]
              [set gene-path44 go2 gene1 gene2]     ]
       ;show gene-path44
      ; show "44"
       ;show "2"
       ;show gene2
       set male 1]
   ; set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
     ; if random-float 1 > huo[
     ; set pcolor  black]
      if male = 1 [
    if count  neighbors with [pcolor = black] > 0[
    ask one-of neighbors with [pcolor = black][
        anti-color
        ;anti-colorsim
      set gene1 gene-path33
         ; show gene1
        ;show "1"
          ;show gene-path44
      set gene2 gene-path44
        ;show gene2
        ;show "2"
     ifelse random 2  = 1
    [set sex 1]
    [set sex 0]
              if gene1 = 0[stop]
              if gene2 = 0[stop]

      set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
            set male  0;导致死亡过快。
             ; show "+1"

    ]]]
stop]
  ]]
 ; show "1"
  destroy
  tick
end
to destroy
  set ii  0
  loop[
    ask one-of patches [
    set pcolor black
    ask neighbors[set pcolor black]
  ]
        set ii  ii + 1
      if ii > disturbance [stop]
  ]
end
to go-species
      ask patches[set rain-local rain + random-normal 0 0.025]
    if ticks mod 1000 = 0
[ ifelse random 2 = 1
    [ rain-plus]
    [ rain-minus
    ]
    ;random-norm al mean standard-deviation
  ; do something
]

  ask patches[
    ;show gene2
     if phynotype = 0 [set pcolor black];防止错误数据
    set rain-local rain + random-normal 0 0.025
    if pcolor != black[
      ;show "33";这里存在循环进不去的问题
      set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
      if random-float 1 > huo[
      set pcolor  black]
      loop[ if pcolor = blue  [if ticks mod 9 != 0 [stop]]
        if pcolor = red  [if ticks mod 9 != 0 [stop]]
        get-color
    ;get-colorsim;获得color1，包涵斑块颜色。
      if sex = 0 [


       ifelse random 2  = 1
          [ifelse per > 0.7
            [set gene_path11 gene1]
              [set gene_path11 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene_path22 gene2]
              [set gene_path22 go2 gene1 gene2]     ];赋值操作导致了原变量丢失？
        ;show gene-path33
        ;show "33"
;if count neighbors with [pcolor = color1 and sex = 1] > 0[
      ;ask  one-of neighbors with [pcolor = color1 and sex = 1][;
      ifelse random 2  = 1
                    [ifelse per > 0.7
            [set gene-path33 gene1]
              [set gene-path33 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene-path44 gene2]
              [set gene-path44 go2 gene1 gene2]     ]
       ;show gene-path44
      ; show "44"
       ;show "2"
       ;show gene2
       set male 1]
   ; set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
     ; if random-float 1 > huo[
     ; set pcolor  black]
      if male = 1 [
    if count  neighbors with [pcolor = black] > 0[
    ask one-of neighbors with [pcolor = black][
        anti-color
        ;anti-colorsim
      set gene1 gene-path33
         ; show gene1
        ;show "1"
          ;show gene-path44
      set gene2 gene-path44
        ;show gene2
        ;show "2"
     ifelse random 2  = 1
    [set sex 1]
    [set sex 0]
              if gene1 = 0[stop]
              if gene2 = 0[stop]

      set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
            set male  0;导致死亡过快。
             ; show "+1"

    ]]]
stop]
  ]]
 ; show "1"
  tick
end
to try

ask patches[set rain-local rain + random-normal 0 0.025]
    if ticks mod 1000 = 0[
 ifelse random 2 = 1
    [ rain-plus]
    [ rain-minus
  ]]

  ask patches [ if pcolor = white  [grass]
    if pcolor = yellow  [grass]
    if pcolor = blue  [trees1]
    if pcolor = white  [trees1]




  ]


tick
end
to grass
   ask patches [
    ;show gene2
     if phynotype = 0 [set pcolor black];防止错误数据

    if pcolor != black[
      ;show "33";这里存在循环进不去的问题
      set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
      if random-float 1 > huo[
      set pcolor  black]
      loop[ ;if pcolor = blue  [if ticks mod 9 != 0 [stop]]
        ;if pcolor = red  [if ticks mod 9 != 0 [stop]]
        get-color
    ;get-colorsim;获得color1，包涵斑块颜色。
      if sex = 0 [


       ifelse random 2  = 1
          [ifelse per > 0.7
            [set gene_path11 gene1]
              [set gene_path11 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene_path22 gene2]
              [set gene_path22 go2 gene1 gene2]     ];赋值操作导致了原变量丢失？
        ;show gene-path33
        ;show "33"
;if count neighbors with [pcolor = color1 and sex = 1] > 0[
      ;ask  one-of neighbors with [pcolor = color1 and sex = 1][;
      ifelse random 2  = 1
                    [ifelse per > 0.7
            [set gene-path33 gene1]
              [set gene-path33 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene-path44 gene2]
              [set gene-path44 go2 gene1 gene2]     ]
       ;show gene-path44
      ; show "44"
       ;show "2"
       ;show gene2
       set male 1]
   ; set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
     ; if random-float 1 > huo[
     ; set pcolor  black]
      if male = 1 [
    if count  neighbors with [pcolor = black] > 0[
    ask one-of neighbors with [pcolor = black][
        anti-color
        ;anti-colorsim
      set gene1 gene-path33
         ; show gene1
        ;show "1"
          ;show gene-path44
      set gene2 gene-path44
        ;show gene2
        ;show "2"
     ifelse random 2  = 1
    [set sex 1]
    [set sex 0]
              if gene1 = 0[stop]
              if gene2 = 0[stop]

      set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
            set male  0;导致死亡过快。
             ; show "+1"

    ]]]
stop]
  ]
    ; show "1"
  ]



end
to trees1
  ask patches[
if phynotype = 0 [set pcolor black];防止错误数据

    if pcolor != black[
      ;show "33";这里存在循环进不去的问题
      set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
    loop [   if pcolor = blue  [if ticks mod 9 != 0 [stop]]
        if pcolor = red  [if ticks mod 9 != 0 [stop]]
    if random-float 1 > huo[
      set pcolor  black]
    ]
      loop[ if pcolor = blue  [if ticks mod 9 != 0 [stop]]
        if pcolor = red  [if ticks mod 9 != 0 [stop]]
        get-color
    ;get-colorsim;获得color1，包涵斑块颜色。
      if sex = 0 [


       ifelse random 2  = 1
          [ifelse per > 0.7
            [set gene_path11 gene1]
              [set gene_path11 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene_path22 gene2]
              [set gene_path22 go2 gene1 gene2]     ];赋值操作导致了原变量丢失？
        ;show gene-path33
        ;show "33"
;if count neighbors with [pcolor = color1 and sex = 1] > 0[
      ;ask  one-of neighbors with [pcolor = color1 and sex = 1][;
      ifelse random 2  = 1
                    [ifelse per > 0.7
            [set gene-path33 gene1]
              [set gene-path33 go1 gene1 gene2]      ]

            [ifelse per > 0.7
              [set gene-path44 gene2]
              [set gene-path44 go2 gene1 gene2]     ]
       ;show gene-path44
      ; show "44"
       ;show "2"
       ;show gene2
       set male 1]
   ; set huo   (1 - d) * exp (-(((phynotype - rain-local) ^ 2))/ omega )
     ; if random-float 1 > huo[
     ; set pcolor  black]
      if male = 1 [
    if count  neighbors with [pcolor = black] > 0[
    ask one-of neighbors with [pcolor = black][
        anti-color
        ;anti-colorsim
      set gene1 gene-path33
         ; show gene1
        ;show "1"
          ;show gene-path44
      set gene2 gene-path44
        ;show gene2
        ;show "2"
     ifelse random 2  = 1
    [set sex 1]
    [set sex 0]
              if gene1 = 0[stop]
              if gene2 = 0[stop]

      set phynotype (sum gene1 + sum gene2) / 40 + random-normal 0 0.025
            set male  0;导致死亡过快。
             ; show "+1"

    ]]]
stop]
  ]
 ; show "1"
  ]

end

to get-color
  if pcolor = white[
    set color1  "white"]
  if pcolor = blue[
    set color1  "blue"]
  if pcolor = red[
    set color1  "red"]
  if pcolor = yellow[
    set color1  "yellow"]
end
to get-colorsim
  set color1 pcolor
end
to anti-colorsim
  set pcolor color1
end
to anti-color
  if color1 = "white"[
  set pcolor  white]
  if color1 = "yellow"[
  set pcolor  yellow]
  if color1 = "blue"[
  set pcolor  blue]
  if color1 = "red"[
  set pcolor  red]
  ;show count patches with  [ pcolor = white ]
  ;count patches with [phynotype < 0.3 and pcolor = white]
end
to-report transition1 [gene]
  set element []
  ;show "tiaoshi"

  show n
  set i 0
  if per < 2[
     set inner []

    while [i < n][
     set element item i gene
      set inner lput element inner
      show "inner1"
      show inner
  set i  (i + 1)

  ]
  report inner
  ]


end
to-report transition2 [gene]
    set element []
  set i 0
  ;set n  random  length gene
  if per < 2 [
    set inner []
    while [i + n < length gene][
       set element item (n + i ) gene
      set inner lput element inner
      show "inner2"
      show inner

      set i  (i + 1)


        ]
     report  inner
  ]



end
to-report joint [c b ]
  set mix []
 report se c b
end
to-report go1 [genep1  genep2]
  set p 0.3
  set per random-float 1
  show "start"
;py:setup py:python
;py:run "import numpy as np"

;set genep1 py:runresult"np.random.binomial(1, 0.2,5)"
;set genep2 py:runresult"np.random.binomial(1, 0.2,5)"
set n  random  (length genep1)
  ifelse  per < 0.7 [
  ;show n
  ;show "gene1"
  ;show gene1
  ;show "gene2"
  ;show gene2

  set s1 (transition1 genep1)
  set s2 (transition2 genep1)
  ;set s1 first-half
  ;set s2 behind-half

  set s3 transition1 genep2
  set s4 transition2 genep2
    ;set s3 first-half
  ;set s4 behind-half

  set  mix1   joint s1 s4

  set  mix2 joint s3 s2
  ;show "gene1"
  ;show mix1
  ;show "gene2"
  ;show mix2


  report mix1
  ]
  [report genep1]

end
to-report go2 [genep1  genep2]
  set p 0.3
  set per random-float 1
  show "start"
;py:setup py:python
;py:run "import numpy as np"

;set genep1 py:runresult"np.random.binomial(1, 0.2,5)"
;set genep2 py:runresult"np.random.binomial(1, 0.2,5)"
set n  random  (length genep1)
  ifelse  per < 0.7 [
  ;show n
  ;show "gene1"
  ;show gene1
  ;show "gene2"
  ;show gene2

  set s1 (transition1 genep1)
  set s2 (transition2 genep1)
  ;set s1 first-half
  ;set s2 behind-half

  set s3 transition1 genep2
  set s4 transition2 genep2
    ;set s3 first-half
  ;set s4 behind-half

  set  mix1   joint s1 s4

  set  mix2   joint s3 s2
  ;show "gene1"
  ;show mix1
  ;show "gene2"
  ;show mix2


  report mix2
  ]
  [report genep2]

end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1228
1029
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-50
50
-50
50
0
0
1
ticks
120.0

BUTTON
65
10
140
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
20
47
192
80
rain
rain
0
1
0.10000000000000003
0.1
1
NIL
HORIZONTAL

BUTTON
56
157
168
190
NIL
go-unsexual
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
17
123
189
156
omega
omega
0.1
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
19
88
191
121
d
d
0
1
0.1
0.1
1
NIL
HORIZONTAL

BUTTON
56
239
168
272
NIL
go-unsexual
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
53
202
173
235
NIL
go-sexual\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
57
512
229
545
fanzhilv-sex
fanzhilv-sex
0
100
44.0
1
1
NIL
HORIZONTAL

BUTTON
64
281
154
314
NIL
go-plant\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
40
361
240
511
plot 1
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"white" 1.0 0 -16777216 true "" "plot count patches with [pcolor = white]"
"yellow" 1.0 0 -1184463 true "" "plot count patches with [pcolor = yellow]"
"blue" 1.0 0 -13791810 true "" "plot count patches with [pcolor = blue]"
"red" 1.0 0 -5298144 true "" "plot count patches with [pcolor = red]"
"rain" 1.0 0 -10141563 true "" "plot rain * 10000"

BUTTON
67
322
172
355
NIL
go-species
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
54
558
117
591
NIL
try
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
171
291
343
324
disturbance
disturbance
0
500
100.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go-plant</go>
    <timeLimit steps="999"/>
    <metric>plot count patches with [pcolor = white]</metric>
    <steppedValueSet variable="rain" first="0" step="1" last="0.1"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
