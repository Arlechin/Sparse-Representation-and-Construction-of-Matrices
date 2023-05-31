%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%
%%%%%%
% Author: Γιώργος Πάκας, Ημ/νία εκκίνησης: 21/11/21 Ημ/νία ολοκλήρωσης: 30/11/21




function [sp_blockToeTrid] = blkToeplitzTrid(n,B,A,C)
    
    if(nargin~=4)%έλεγχος αριθμού εισόδων
        error('blkToeplitzTrid: Function requires 4 inputs'); 
    end
    
    if (length(size(B))~=2) || (length(size(A))~=2) || (length(size(C))~=2) %έλεγχος για μη δισδιάστατη είσοδο
        error('blkToeplitzTrid: Blocks can only be two-dimensional');
    end
    
    if(any(size(A)~=size(B)) || any(size(A)~=size(C))) %Μείωση του vector τιμών(size()) σε μια συνθήκη για το αν κάποιο απο τα blocks έχει άνισες διαστάσεις με τα υπόλοιπα
        error('blkToeplitzTrid: The three blocks are not of the same dimensions');
    end
    
    if((length(n)>1) || (isempty(n)) || (n<1) || (n~= floor(n))) %1)βαθμωτός 2)μη-μηδενικός 3)θετικός 4)ακέραιος
        error('blkToeplitzTrid: The number of the main diagonal must be a positive integer scalar');
    end
    
    if isempty(A)%έλεγχος μηδενικής διάστασης
        error('blkToeplitzTrid: Block must not be empty, please input non-empty dimension(s)'); 
    end
    
    
    
    [dimRow,dimCol] = size(A);
    
    if(dimRow*dimCol == 1) 
        if(n == 1) %αν MD βαθμωτός και πλήθος block κύριας διαγωνίου ίσον 1 τότε το BlockToeTridiag μητρώο είναι το Block κύριας διαγωνίου
            blockToeTrid = A;
        else %αν MD βαθμωτός και πλήθος block κύριας διαγωνίου διάφορο του 1 τότε το BlockToeTridiag μητρώο είναι nxn δομημένο απο τις στήλες του [B A C] στις υπο:υπέρ διαγωνίους
            blockToeTrid = spdiags(repmat([B A C], n, 1), -1:1, n, n); 
        end
        full_blockToeTrid = full(blockToeTrid);
        disp(full_blockToeTrid);
        disp(blockToeTrid);
        return  
    end
    
    blockToeTrid = repmat(A(:), n, 1);
    
    if(n > 1)
        blockToeTrid = [blockToeTrid; repmat(B(:), n-1, 1)];
        blockToeTrid = [blockToeTrid; repmat(C(:), n-1, 1)];
    end
    %%%%%%%%
    [idx_1, idx_2, idx_3] = ndgrid(0:dimRow-1, 0:dimCol-1, 0:n-1); 
    
    row_idx = 1+idx_1(:) + dimRow*idx_3(:);
    col_idx = 1+idx_2(:) + dimCol*idx_3(:);
    
    if(n > 1)
        [idx_1,idx_2,idx_3] = ndgrid(0:dimRow-1, 0:dimCol-1, 0:n-2);
        row_idx = [row_idx; 1 + dimRow + idx_1(:) + dimRow*idx_3(:)];
        col_idx = [col_idx; 1 + idx_2(:) + dimCol*idx_3(:)];
            
        row_idx = [row_idx;1+idx_1(:)+dimRow*idx_3(:)];
        col_idx = [col_idx; 1 + dimCol + idx_2(:) + dimCol*idx_3(:)];
        
    end
    sp_blockToeTrid = sparse(row_idx, col_idx, blockToeTrid, dimRow*n, dimCol*n);
    
    full_blockToeTrid = full(sp_blockToeTrid);
    disp(full_blockToeTrid);
    
                    
end