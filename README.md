# Sparse-Representation-and-Construction-of-Matrices
A short dive into Scientific Computing using Matlab and LaTeX.


The goal here is to create concise functions which work on constructing and representing sparse forms of matrices.

Firstly, "sp_mat2latex.m" returns the sparse CSR and CSC representation of a matrix in LaTeX code, targeting a particular visual result. 

Secondly, "blkToeplitzTrid.m" is given square matrices A, B, C of size "m x m" to construct the sparse form of a block Toeplitz Tridiagonal Matrix of size "mn x mn". 

Finally, "sp_mx2bccs.m" is given a sparse square matrix A and a block size(nb) to return a Block Compressed Column Storage(BCCS) representation. To achieve that, it uses mat2tiles, a matlab function, created by Matt Jacobson.

sp_mat2latex visual result:
![sp_mat2latex](https://github.com/Arlechin/Sparse-Representation-and-Construction-of-Matrices/blob/main/sp_matrix2latex2.png?raw=true)
---
blkToeplitzTrid result:
![blkToeplitzTrid](https://github.com/Arlechin/Sparse-Representation-and-Construction-of-Matrices/blob/main/blkToeplitzTrid.png?raw=true)
---
sp_mx2bccs result:
![sp_mx2bccs](https://github.com/Arlechin/Sparse-Representation-and-Construction-of-Matrices/blob/main/sp_mx2bccs.png?raw=true)
---
