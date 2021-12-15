# Packages -----------------------------------------------------------------------------------------

library(tidyverse)
library(tidymodels)
library(broom)
library(skimr)
library(ggplot2)
library(corrplot)
library(vip)
library(naniar)
library(visdat)
library(tidymodels)

# Data -----------------------------------------------------------------------------------------

dados <- read.csv("C:\\Users\\mcaio\\Desktop\\regressao linear\\Car details v3.csv")

any(is.na(dados))

dados %>% head(5)


visdat::vis_miss(dados)

dados <- dados %>% drop_na()


dados <- 
  dados %>% 
  mutate(mileage = str_remove_all(mileage, "[[:alpha:]]"),
         engine = str_remove_all(engine, "[[:alpha:]]"),
         max_power = str_remove_all(max_power, "[[:alpha:]]"),
         selling_price = log(selling_price),
         mileage = str_remove_all(mileage, "\\D"),
         age = 2021 - year,
         age = log(age))

dados %>% group_by(seller_type) %>% count()


dados <- dados %>% filter(seller_type != "Trustmark Dealer")
dados <- dados %>% filter(owner != "Test Drive Car")



dados <- dados %>% mutate(mileage = as.numeric(mileage),
                          engine = as.numeric(engine),
                          max_power = as.numeric(max_power),
                          max_power = log(max_power),
                          km_driven = log(km_driven))



# EDA -----------------------------------------------------------------------------------------

skimr::skim(dados)

glimpse(dados)


dados %>% ggplot(aes(selling_price))+ geom_boxplot()
dados %>% ggplot(aes(selling_price))+ geom_histogram()

dados %>% ggplot(aes(selling_price,km_driven))+
  geom_point()+
  geom_smooth(method = "lm")


dados %>% select(where(is.numeric)) %>% cor() %>% corrplot(method = 'square')

# Split -----------------------------------------------------------------------------------------

carros_split <- initial_split(dados, prop = 0.7)

carros_treino <- training(carros_split)

carros_teste <- testing(carros_split)


# Recipes -----------------------------------------------------------------------------------------

carros_recipes <- recipe(selling_price ~., carros_treino) %>% 
  step_rm(torque, name,year,mileage, skip = TRUE) %>% 
  step_novel(all_nominal()) %>% 
  step_dummy(all_nominal()) %>% 
  step_zv(all_numeric(), -all_outcomes()) %>% 
  step_corr(all_numeric(), -all_outcomes())

names(juice(prep(carros_recipes)))


# Modelo -----------------------------------------------------------------------------------------

linear_reg <- linear_reg() %>% 
  set_engine("lm")


# Workflow -----------------------------------------------------------------------------------------

carros_wf <- workflow() %>% 
  add_model(linear_reg) %>% 
  add_recipe(carros_recipes)


# Cross Validation-----------------------------------------------------------------------------------------

carros_cv <- vfold_cv(carros_treino, v = 5)


# Fit Resamples-----------------------------------------------------------------------------------------

carros_fitR <- fit_resamples(carros_wf, 
                             resamples = carros_cv,
                             metrics = metric_set(rmse, rsq),
                             control = control_resamples(save_pred = TRUE, allow_par = FALSE, verbose = TRUE))

carros_fitR %>% unnest(.metrics)

collect_metrics(carros_fitR)
collect_predictions(carros_fitR)

collect_predictions(carros_fitR) %>% ggplot(aes(.pred, selling_price))+
  geom_point()+
  geom_smooth(method = "lm")




# Last Fit -----------------------------------------------------------------------------------------

carros_lf <- carros_wf %>% last_fit(carros_split)

collect_metrics(carros_lf)
collect_predictions(carros_lf)


collect_predictions(carros_lf) %>% ggplot(aes(.pred, selling_price))+
  geom_point()+
  geom_smooth(method = "lm")


# Fit-----------------------------------------------------------------------------------------

carros_fit_final <- carros_wf %>% fit(carros_treino)
tidy(carros_fit_final)


# Predict -----------------------------------------------------------------------------------------


results_train <- carros_fit_final %>% predict(new_data = carros_treino) %>% mutate(truth = carros_treino$selling_price)

results_test <- carros_fit_final %>% predict(new_data = carros_teste) %>% mutate(truth = carros_teste$selling_price)



results_train %>% rmse(truth = truth, estimate = .pred)

results_test %>% rmse(truth = truth, estimate = .pred)

results_train %>% rsq(truth = truth, estimate = .pred)

results_test %>% rsq(truth = truth, estimate = .pred)


results_test %>% ggplot(aes(truth, .pred))+
  geom_point()+
  geom_smooth(method = "lm")


# RESIDUOS-----------------------------------------------------------------------------------------


results_test$residuo <- results_test$truth - results_test$.pred

results_test %>% ggplot(aes(.pred, residuo))+
  geom_pointrange(aes(ymin = 0, ymax = residuo), color = "blue")+
  geom_hline(yintercept = 0, linetype = 3, color = "red")

results_test %>% ggplot(aes(.pred, residuo))+
  geom_point(aes(), color = "blue")+
  geom_hline(yintercept = 0, linetype = 3, color = "red")




results_test %>% ggplot(aes(.pred, residuo))+
  geom_point()+
  geom_smooth(se = FALSE)


ggplot(results_test, aes(x = residuo)) + 
  geom_histogram(bins = 15, fill = "blue") +
  geom_density()+
  ggtitle("Histogram of residuals")



# Mas quais são as variáveis mais importantes ?


vip(carros_fit_final$fit$fit) +
  ggtitle("Variáveis mais importantes no nosso modelo de Regressão Linear")+
  theme_bw()


