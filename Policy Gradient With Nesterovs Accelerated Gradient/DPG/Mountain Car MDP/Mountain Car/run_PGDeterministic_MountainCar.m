%function for Stochastic Policy Gradient
function [Step_Size_Results, Cum_Rwd_Sigma] = run_PGDeterministic_MountainCar ()

%%set up an MDP 
noise=0.01;
gamma=0.99;
H=100;  
Actions = 9;

%parameters for the agent
centres = 50;

%setting up the MDP here
mdp = MountainCar(noise, gamma, H, Actions);

%mdp_type_kernels = AllKernels (GridWorldKernel(mdp));
agent_kernel_type = GridWorldKernel(mdp); %make a same version of PendulumKernel - to be used with Pend MDPs

experiments = 10;
iterations = 700;


sigma = [0:0.05:0.5];

cumulativeReward = zeros(experiments,iterations+1);
Step_Size_Results ={};
Cum_Rwd_Sigma={length(sigma)};

%range of Nesterovs mmtm values
b_step = [10, 100, 200, 500, 1000, 1500];
momentum = [0.999, 0.995, 0.99, 0.9, 0];


for s = 1:length(sigma)
    for a = 1:length(momentum)
     for b = 1:length(n_epsilon)
        for i = 1:experiments  
    fprintf(['\n**** EXPERIMENT NUMBER p = ', num2str(i), ' ******\n']); 

    agentKernel = agent_kernel_type.Kernels_State(sigma(s));     %Gaussian Kernel
    agent = Agent(centres, sigma(s), agentKernel, mdp); 
    [cum_rwd] = PGDeterministic(agent, mdp, iterations, momentum(a), b_step(b), sigma(s));    
    cumulativeReward(i, :) = cum_rwd; 
    save 'Each Experiment Result.mat'
 
        end   
    meanReward = mean(cumulativeReward(:,:));
    Step_Size_Results{a,b} = meanReward;
    
     end
      save 'Average Results for current Step-Size params.mat'
    end   
    Cum_Rwd_Sigma{s,:} = Step_Size_Results;
        save 'Current Sigma Results.mat'
end

    %save results
    save 'All Results DPG Nesterovs Method Mountain Car MDP.mat'


end
    




