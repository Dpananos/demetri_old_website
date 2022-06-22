
data{

  int y_1_1; //number of concurrent 1s
  int y_0_1; //number of 0,1 occurences
  int y_1_0; //number of 1,0 occurences
  int y_0_0; //number of concurrent 0s
  
}
transformed data{
    int y[4] = {y_1_1, y_0_1, y_1_0, y_0_0};
}
parameters{
  real<lower=-1, upper=1> rho;
  real<lower=0, upper=1> q;
}
transformed parameters{
  real<lower=0, upper=1> prob_1_1 = q + rho*(1-q);
  real<lower=0, upper=1> prob_0_1 = (1-q)*(1-rho);
  real<lower=0, upper=1> prob_1_0 = q*(1-rho);
  real<lower=0, upper=1> prob_0_0 = 1 - q + rho*q;
  simplex[4] theta = 0.5*[prob_1_1, prob_0_1, prob_1_0, prob_0_0 ]';
}
model{
  q ~ beta(1, 1);
  rho ~ uniform(-1, 1);
  y ~ multinomial(theta);
  
}
generated quantities{
    vector[300] yppc;
    
    yppc[1] = bernoulli_rng(q);
    
    for(i in 2:300){
        if(yppc[i-1]==1){
            yppc[i] = bernoulli_rng(prob_1_1);
        }
        else{
        yppc[i] = bernoulli_rng(prob_1_0);
        }
    }
}
