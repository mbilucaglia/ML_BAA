function [id_event_out] = event_translation(id_event_in)

id_event_out=strings(size(id_event_in));

n_stim=numel(id_event_in);

for i=1:n_stim
    event_temp=num2str(id_event_in(i));
    
    if numel(event_temp)==2
            start_digit=event_temp(1);
            
            switch start_digit
                case '1'
                    id_event_out(i)="Ps-L-Im";
                case '2'
                    id_event_out(i)="Ps-H-Im";
                case '3'
                    id_event_out(i)="Ps-L-So";
                case '4'
                    id_event_out(i)="Ps-H-So";
                case '5'
                    id_event_out(i)="Ac-L-Im";
                case '6'
                    id_event_out(i)="Ac-H-Im";
                case '7'
                    id_event_out(i)="Ac-L-So";
                case '8'
                    id_event_out(i)="Ac-H-So";
                otherwise
                    id_event_out(i)="Unknown";
            end
        
        
    elseif numel(event_temp)==3
        
        start_digit=event_temp(1:2);
        
        switch start_digit
            case '11'
                id_event_out(i)="Pr-L-Im";
            case '12'
                id_event_out(i)="Pr-H-Im";
            case '13'
                id_event_out(i)="Pr-L-So";
            case '14'
                id_event_out(i)="Pr-H-So";
            otherwise
                id_event_out(i)="Unknown";
        end
                
            
        
    else
        id_event_out(i)="Unknown";
    end


end

end

