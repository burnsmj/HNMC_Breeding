### FarmCPU GWAS Manhattan Plotting
### Michael Burns
### 1/13/25

# Libraries
library(tidyverse)

# Data
files = list.files('~/HNMC_Breeding/Analysis/', pattern = 'GWAS.Results.csv', recursive = T)

# Create a storage table for each trait
gwas_data = tibble()

# Create a loop to read in data and add it to the storage tables
for(file in files){
  year = paste0('20', str_remove(str_split(file, '[_/]')[[1]][1], 'YCH'))
  model = str_split(file, '[_/]')[[1]][2]
  print(paste0('---', year, ' ', model, '---'))
  gwas_data = gwas_data %>%
    bind_rows(suppressMessages(read_csv(paste0('~/HNMC_Breeding/Analysis/', file))) %>%
                select(SNP, Chromosome, Position, P.value, effect) %>%
                mutate(Year = year,
                       Model = model))
}

# Arrange data
gwas_data_to_plot = gwas_data %>%
  arrange(Chromosome, Position) %>%
  group_by(Year, Model) %>%
  mutate(bp_cumm = row_number(),
         Model = str_replace(Model, 'Add', 'Additive'),
         Model = str_replace(Model, 'Dom', 'Dominance'))

# Find chromosome centers
manhat_chr_centers = gwas_data_to_plot %>%
  group_by(Chromosome) %>%
  summarise(center = mean(bp_cumm))

# GWAS Plotting
gwas_plot = gwas_data_to_plot %>%
  ggplot(aes(x = bp_cumm, y = -log10(P.value), color = as.character(Chromosome)))+
  geom_hline(yintercept = -log10(0.05 / (nrow(gwas_data_to_plot) / 4)), linetype = 'dashed', alpha = 0.5)+
  geom_point(show.legend = F)+
  scale_x_continuous(label = manhat_chr_centers$Chromosome,
                     breaks = manhat_chr_centers$center,
                     expand = c(0,0))+
  facet_grid(Year+Model~.)+
  scale_color_manual(breaks = rep(as.character(c(1:10)), 4),
                     values = rep(c('black', 'gray40'), 20))+
  labs(x = 'Chromosome',
       y = '-log(p)')+
  theme_classic()+
  theme(text = element_text(size = 12, color = 'black'))

# View the plot
gwas_plot

# Save the plot
ggsave('~/HNMC_Breeding/Analysis/gwas_manhattan.png', plot = gwas_plot, device = 'png', width = 7.5, height = 4.5, units = 'in', dpi = 300)
