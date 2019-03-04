classdef subject < handle
   %Test subject in population
   properties
      position
      status
      age
   end
   methods
       function sub = subject(x,y,s,a)
           sub.position = [x,y];
           sub.status = s;
           sub.age = a;
       end
       function delete(sub)
       end
       function sub = move(sub)
           dx = randn;
           dy = randn;
           mag = 5;
           dx = mag*dx;
           dy = mag*dy;
           pos = sub.position;
           
           pos(1) = pos(1) + dx;
           if pos(1) < 0
               pos(1) = -pos(1);
           end
           if pos(1) > 100
               pos(1) = 100 - (pos(1) - 100);
           end
           
           pos(2) = pos(2) + dy;
           if pos(2) < 0
               pos(2) = -pos(2);
           end
           if pos(2) > 100
               pos(2) = 100 - (pos(2) - 100);
           end
           sub.position = pos;
       end
           
       function [type,infect] = checkStatus(sub, sub2, d, beta)
           r = rand();
           infection_rate = exp(-d*beta);
           if sub2.status == 'I'
               if isequal(sub.status,'Sv')
                   if r <= infection_rate
                        infect = true;
                        type = 'Sv';
                        return;
                   else
                       infect = false;
                       type = '';
                   end
              elseif isequal(sub.status,'Si')
                   if r <= infection_rate
                        infect = true;
                        type = 'Si';
                        return;
                   else
                       infect = false;
                       type = '';
                   end                       
               end
           elseif sub.status == 'I'
               if isequal(sub2.status,'Sv')
                   if r <= infection_rate
                        infect = true;
                        type = 'Sv';
                        return;
                   else
                       infect = false;
                       type = '';
                   end
              elseif isequal(sub2.status,'Si')
                   if r <= infection_rate
                        infect = true;
                        type = 'Si';
                        return;
                   else
                       infect = false;
                       type = '';
                   end                       
               end
           else
               infect = false;
               type = '';
           end
           infect = false;
           type = '';
       end
       function [close,dist] = inRadius(sub, subs, r)
          j = 1;
          close = [];
          dist = [];
          pos1 = sub.position;
          for ind = 1:length(subs)
              pos2 = subs(ind).position;
              d = pdist2(pos1,pos2);

              if d <= r^2
                  if subs(ind) ~= sub
                      close(j) = ind;
                      dist(j) = d;
                      j = j + 1;
                  end
              else
              end
          end
       end
       function checkRecover(sub, gamma)
           r = rand;
           if sub.status == 'I'
               if r < gamma
                   sub.status = 'R';
                   return;
               else
                   return;
               end
           else
               return;
           end
       end
       function vac = checkAge(sub, vac_rate, wane_rate)
           r = rand;
           a = sub.age;
           if sub.status == 'Si'
               if a == 4 || a == 6 || a == 12 || a == 24
                   if r < vac_rate
                       sub.status = 'R';
                       vac = true;
                       return;
                   else
                       sub.status = 'Sv';
                       vac = false;
                       return;
                   end
               end
           end
           if sub.status == 'R'
               if mod(a,6) == 0
                   if r < wane_rate
                       sub.status = 'Si';
                   end
               end
           end
%            if sub.status == 'R'
%                if r < (0.1*a)/(0.4*a + 1)
%                    sub.status = 'Si';
%                end
%            end
           vac = false;
       end
   end
end