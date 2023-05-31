%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%
%%%%%%
% Author: Γιώργος Πάκας, Ημ/νία εκκίνησης: 21/11/21, Ημ/νία ολοκλήρωσης: 21/11/2021

function [val,row_ip,col_ip] = sp_matrix2latex2(matrix,sp_type,filename) 
% INPUTS--> matrix: Μη συμπιεσμένο μητρώο, sp_type: τύπος συμπίεσης(csr/csc), filename: αρχείο ελέγχου('test.tex') 

%Brief summary of this function.
%Detailed explanation of this function.

    if(nargin ~= 3)
        error('sp_matrix2latex2: Incorrect number of arguments,please limit the number of arguments to 2');
    end

    height = size(matrix,1); % πλήθος γραμμών
    width = size(matrix,2); % πλήθος στηλών
    totalNumberOfElements = height*width; % συνολικό πλήθος στοιχείων
    
    val = []; % Vector τιμών μη-μηδενικών στοιχείων κατά γραμμές(CSR)/στήλες(CSC)
    
    row_ip = []; % Vector στηλών(CSR)/γραμμών(CSC) μη-μηδενικών στοιχείων
    
    col_ip = []; % Vector αλλαγής γραμμών(CSR)/στηλών(CSC) μη-μηδενικών στοιχείων
    
    totalNumOfNonZero = nnz(matrix); %πλήθος μη μηδενικών στοιχείων
    
    totalNoOfZero = nnz(~matrix);
    
    fid = fopen(filename,'w'); % εγγραφή σε αρχείο για εύκολο έλεγχο λειτουργίας
    
    %%%%%%Errors
    if(totalNoOfZero == 0) %έλεγχος βάρους μητρώου
        error('sp_matrix2latex2: Matrix has no zero elements, please input sparse matrix');
    elseif(isempty(matrix))
        error('sp_matrix2latex2: Matrix has no non-zero elements, please input sparse matrix containing at least 1 non-zero element');
    end
    %%%%%%%  
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% CSR process %%%%%%
        if(sp_type=='csr')
            %%% Formatting for LaTeX
            fprintf(fid,'$$ val = \\begin{tabular}{ |');
            if(totalNumOfNonZero==1)
                fprintf(fid,' l |');
            else
                
                for i=1:totalNumOfNonZero
                    fprintf(fid,' l |');
                end
                
            end    
            fprintf(fid,' }\\hline\r\n');
            %%%%%%
            %%%%%% CSR val vector filling and printing in file in file
            nnZElementsFound = 0;
            for i = 1 : height
                for j = 1 : width
                    
                    if(matrix(i,j) ~= 0)
                        if(nnZElementsFound == totalNumOfNonZero-1)
                            fprintf(fid, '%f %s \\hline\r\n',matrix(i,j),'\\');
                            val = [val matrix(i,j)];
                        else
                            fprintf(fid,'%f & ',matrix(i,j));
                            val = [val matrix(i,j)];
                            nnZElementsFound = nnZElementsFound + 1;
                        end
                        
                    end
                    
                end    
            end
            %%% Formatting for LaTeX
            fprintf(fid,'\\end{tabular}$$\r\n$$ IA = \\begin{tabular}{ |');        
            if(totalNumOfNonZero==1)
                fprintf(fid,' l |');
            else
                
                for i=1:totalNumOfNonZero
                    fprintf(fid,' l |');    
                end
                
            end
            fprintf(fid,' }\\hline\r\n');
            %%%%%%
            %%%%%% IA cells or CSR row_ip cells - vector filling & printing
            nnzCounter = 0;
            for i=1:height
                for j=1:width
                    
                    if(matrix(i,j)~=0 && (nnzCounter+1 == totalNumOfNonZero))
                        fprintf(fid,'%d %s \\hline\r\n',j,'\\');
                        row_ip = [row_ip j];
                        break
                    elseif(matrix(i,j)~=0 && (nnzCounter ~= totalNumOfNonZero))
                        fprintf(fid,'%d & ',j);
                        row_ip = [row_ip j];
                        nnzCounter = nnzCounter + 1;
                    end
                    
                end
            end
            fprintf(fid,'\\end{tabular}$$\r\n$$ JA = \\begin{tabular}{ |');
            %%% Formatting for LaTeX
            if(totalNumOfNonZero == 1)
                fprintf(fid,' l | l |');
            else
                
                for i=1:(height + 1)
                    fprintf(fid,' l |');
                end
                
            end
            %%% Formatting for LaTeX
            fprintf(fid,' }\\hline\r\n');
            %%%%%%
            %%%%%% JA cells or CSR col_ip cells - vector filling & printing
            posFirstNNZ = 0;
            for i = 1 : height
                foundFirst = 0;
                for j = 1 : width
                    
                    if(matrix(i,j) ~=0 ) 
                        posFirstNNZ = posFirstNNZ + 1;
                        if(foundFirst == 0)
                            col_ip = [col_ip posFirstNNZ];
                            foundFirst = 1;
                        end
                        
                        if(posFirstNNZ == totalNumOfNonZero)
                            col_ip = [col_ip (posFirstNNZ + 1)]; 
                        end
                        
                    end
                    
                end
                
            end
        
            %%% Printing
            for i = 1 :(length(col_ip))
                
                if(i == length(col_ip))
                    fprintf(fid,'%d %s \\hline\r\n\\end{tabular}$$',col_ip(i),'\\');
                else
                    fprintf(fid,'%d & ',col_ip(i));
                end
                
            end
            
            
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%    
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% CSC process  %%%%%%    
        elseif(sp_type == 'csc') 
            %%% Formatting for LaTeX
            fprintf(fid,'$$ val = \\begin{tabular}{ |');
            if(totalNumOfNonZero==1)
                fprintf(fid,' l |');
            else
                
                for i=1:totalNumOfNonZero
                    fprintf(fid,' l |');
                end
                
            end
            %%% Formatting for LaTeX
            fprintf(fid,' }\\hline\r\n');
            %%%%%%
            %%%%%% CSC val vector filling and printing in file
            nnZElementsFound = 0;
            for j = 1 : width
                for i = 1 : height
                    
                    if(matrix(i,j) ~= 0)
                        if(nnZElementsFound == totalNumOfNonZero-1)
                            fprintf(fid, '%f %s \\hline\r\n',matrix(i,j),'\\');
                        else
                        fprintf(fid,'%f & ',matrix(i,j));
                        nnZElementsFound = nnZElementsFound + 1;
                        end
                    end
                    
                end    
            end
            %%% Formatting for LaTeX
            fprintf(fid,'\\end{tabular}$$\r\n$$ row%sidx = \\begin{tabular}{ |','\_');
            
            if(totalNumOfNonZero==1)
                fprintf(fid,' l |');
            else
                
                for i=1:totalNumOfNonZero
                    fprintf(fid,' l |');    
                end
                
            end
            
            fprintf(fid,' }\\hline\r\n');
            
            %%%%%%
            %%%%%% CSC row_ip cells - vector filling & printing 
            nnzCounter = 0;
            for j=1:width
                for i=1:height
                    
                    if(matrix(i,j)~=0 && (nnzCounter+1 == totalNumOfNonZero))
                        fprintf(fid,'%d %s \\hline\r\n',i,'\\');
                        break
                    elseif(matrix(i,j)~=0 && (nnzCounter ~= totalNumOfNonZero))
                        fprintf(fid,'%d & ',i);
                        nnzCounter = nnzCounter + 1;
                    end
                    
                end
            end
            fprintf(fid,'\\end{tabular}$$\r\n$$ col%sidx = \\begin{tabular}{ |','\_');
            %%% Formatting for LaTeX
            if(totalNumOfNonZero == 1)
                fprintf(fid,' l | l |');
            else
                for i=1:(height + 1)
                    fprintf(fid,' l |');
                end
            end
            %%% Formatting for LaTeX
            fprintf(fid,' }\\hline\r\n');
            %%%%%%
            %%%%%% CSC col_ip cells - vector filling & printing
            posFirstNNZ = 0;
            for j = 1 : width
                foundFirst = 0;
                for i = 1 : height
                    if(matrix(i,j) ~=0 ) 
                        posFirstNNZ = posFirstNNZ + 1;
                        if(foundFirst == 0)
                            col_ip = [col_ip posFirstNNZ];
                            foundFirst = 1;
                        end
                        if(posFirstNNZ == totalNumOfNonZero)
                            col_ip = [col_ip (posFirstNNZ + 1)]; 
                        end    
                    end
                    
                end
                
            end
        
        
            for i = 1 :(length(col_ip))
                if(i == length(col_ip))
                    fprintf(fid,'%d %s \\hline\r\n\\end{tabular}$$',col_ip(i),'\\');
                else
                    fprintf(fid,'%d & ',col_ip(i));
                end
            end
        end    
    end    
        
        
 
                    
        
        
        
        
        
        
        
        







