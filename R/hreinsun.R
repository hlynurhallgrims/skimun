cl_rammi <- rammi %>% 
  mutate(dags = dmy(dags)) %>% 
  mutate_at(vars(stofnun, annad),
            ~na_if(., ""))
