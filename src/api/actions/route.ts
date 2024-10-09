import {
    ActionPostResponse,
    createPostResponse,
    ActionGetResponse,
    ActionPostRequest,
    createActionHeaders,
    ActionError,
  } from "@solana/actions";
  import {
    clusterApiUrl,
    Connection,
    LAMPORTS_PER_SOL,
    PublicKey,
    SystemProgram,
    Transaction,
  } from "@solana/web3.js";
  
  // Create the standard headers for this route (including CORS)
  const headers = createActionHeaders();
  
  export const GET = async (req: Request) => {
    try {
      const requestUrl = new URL(req.url);
      const { toPubkey, amount } = validatedQueryParams(requestUrl);
  
      const baseHref = new URL(
        `/api/actions/transfer-sol?to=${toPubkey.toBase58()}&amount=${amount}`,
        requestUrl.origin,
      ).toString();
  
      const payload: ActionGetResponse = {
        type: "action",
        title: "Transfer SOL",
        icon: new URL("/solana_devs.jpg", requestUrl.origin).toString(),
        description: `Transfer ${amount} SOL to ${toPubkey.toBase58()}`,
        label: "Transfer",
        links: {
          actions: [
            {
              label: `Send ${amount} SOL`,
              href: baseHref,
            },
          ],
        },
      };
  
      return new Response(JSON.stringify(payload), {
        headers,
      });
    } catch (err) {
      console.log(err);
      const actionError: ActionError = {
        message: err instanceof Error ? err.message : String(err),
      };
      return new Response(JSON.stringify(actionError), {
        status: 400,
        headers,
      });
    }
  };
  
  // DO NOT FORGET TO INCLUDE THE `OPTIONS` HTTP METHOD
  // THIS WILL ENSURE CORS WORKS FOR BLINKS
  export const OPTIONS = async () => new Response(null, { headers });
  
  export const POST = async (req: Request) => {
    try {
      const requestUrl = new URL(req.url);
      const { amount, toPubkey } = validatedQueryParams(requestUrl);
  
      const body: ActionPostRequest = await req.json();
  
      // Validate the client-provided input
      let account: PublicKey;
      try {
        account = new PublicKey(body.account);
      } catch (err) {
        throw new Error('Invalid "account" provided');
      }
  
      const connection = new Connection(
        process.env.SOLANA_RPC! || clusterApiUrl("devnet"),
      );
  
      // Ensure the receiving account will be rent-exempt
      const minimumBalance = await connection.getMinimumBalanceForRentExemption(0);
      if (amount * LAMPORTS_PER_SOL < minimumBalance) {
        throw new Error(`Amount is too small to be rent-exempt`);
      }
  
      // Create an instruction to transfer native SOL from one wallet to another
      const transferSolInstruction = SystemProgram.transfer({
        fromPubkey: account,
        toPubkey: toPubkey,
        lamports: amount * LAMPORTS_PER_SOL,
      });
  
      // Get the latest blockhash and block height
      const { blockhash, lastValidBlockHeight } = await connection.getLatestBlockhash();
  
      // Create a legacy transaction
      const transaction = new Transaction({
        feePayer: account,
        blockhash,
        lastValidBlockHeight,
      }).add(transferSolInstruction);
  
      const payload: ActionPostResponse = await createPostResponse({
        fields: {
          transaction,
          message: `Send ${amount} SOL to ${toPubkey.toBase58()}`,
        },
      });
  
      return new Response(JSON.stringify(payload), {
        headers,
      });
    } catch (err) {
      console.log(err);
      const actionError: ActionError = {
        message: err instanceof Error ? err.message : String(err),
      };
      return new Response(JSON.stringify(actionError), {
        status: 400,
        headers,
      });
    }
  };
  
  function validatedQueryParams(requestUrl: URL) {
    let toPubkey: PublicKey;
    let amount: number;
  
    // Validate 'to' parameter
    try {
      const toParam = requestUrl.searchParams.get("to");
      if (!toParam) {
        throw new Error("Missing 'to' parameter");
      }
      toPubkey = new PublicKey(toParam);
    } catch (err) {
      throw new Error("Invalid input query parameter: 'to'");
    }
  
    // Validate 'amount' parameter
    try {
      const amountParam = requestUrl.searchParams.get("amount");
      if (!amountParam) {
        throw new Error("Missing 'amount' parameter");
      }
      amount = parseFloat(amountParam);
      if (amount <= 0) throw new Error("Amount must be greater than 0");
    } catch (err) {
      throw new Error("Invalid input query parameter: 'amount'");
    }
  
    return {
      amount,
      toPubkey,
    };
  }