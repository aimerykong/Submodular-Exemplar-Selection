# Selecting Discriminative Points by Submodular Function


  points set-1             |     points set-2          |     points set-3
:-------------------------:|:-------------------------:|:-------------------------:
![]((https://github.com/aimerykong/FossilPollenIdentification_demo_ExemplarSelectionOn2DSynthesisData/raw/master/figures/demo2.jpg)  |  ![](https://github.com/aimerykong/FossilPollenIdentification_demo_ExemplarSelectionOn2DSynthesisData/raw/master/figures/demo1.jpg)   |  ![](https://github.com/aimerykong/FossilPollenIdentification_demo_ExemplarSelectionOn2DSynthesisData/blob/master/figures/demo3.jpg)


![](https://github.com/aimerykong/FossilPollenIdentification_demo_ExemplarSelectionOn2DSynthesisData/raw/master/figures/demo2.jpg)

![](https://github.com/aimerykong/FossilPollenIdentification_demo_ExemplarSelectionOn2DSynthesisData/raw/master/figures/demo1.jpg)

![](https://github.com/aimerykong/FossilPollenIdentification_demo_ExemplarSelectionOn2DSynthesisData/blob/master/figures/demo3.jpg)


 This is a demo for exemplar selection described in our paper
 
    @inproceedings{kong2016spatially,
      title={Spatially aware dictionary learning and coding for fossil pollen identification},
      author={Kong, Shu and Punyasena, Surangi and Fowlkes, Charless},
      booktitle={Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition Workshops},
      year={2016}
    }
 
 As introduced in the paper, the objective function is submodular and 
 monotonically increasing that a greedy algorithm can solve efficiently. 
 Moreover, a lazy greedy method is described for fast implementation. 
 Comment/uncomment the lines in "exemplar selection" cell wil enable the 
 standard greedy algorithm or the lazy greedy one.
 
 This code is to select a set of exemplars discriminatively from a 
 dataset (training set) by solving a well-defined submodular function.
 Run the matlab codes named part5_demo_exemplarSelectionXXXXXX.m will 
 directly give a visualization results on a synthesized 2D dataset.

 For more visualization, please look at the code and uncomment 
 corresponding parts.
 
 This demo will be updated when necessary.
 
 Other demo codes in our fossil pollen project will be released soon, 
 please stay tuned.
 
 For questions, please contact
 
 Shu Kong (Aimery) aimerykong AT gmail com
 
 The code is writen by

           Shu Kong (Aimery)

           Dec. 2013, release version available on Jan. 13, 2014
